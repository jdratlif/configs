import re
import sys
from getpass import getpass, getuser

import requests
import yaml


def main():
    clouds = ["grnoc", "i2", "nwave", "scinet"]
    teams = ["ics", "mis", "nac", "sea", "sms"]

    try:
        with open("groups.yaml", "r") as f:
            groups = yaml.safe_load(f)
    except OSError:
        print(
            "Unable to open groups regex configuration file groups.yaml",
            file=sys.stderr,
        )
        sys.exit(1)

    user = getuser()
    password = getpass("GRNOC GHE Token: ")

    cloud_hosts = dict()
    cloud_vars = dict()

    for cloud in clouds:
        url = (
            "https://raw.github.grnoc.iu.edu/Ansible/ansible-inventory/main/"
            f"{cloud}.yaml"
        )
        data = yaml.safe_load(requests.get(url, auth=(user, password)).text)

        cloud_data = data["all"]["children"][f"cloud_{cloud}"]
        cloud_children = cloud_data["children"]

        cloud_hosts[cloud] = dict()
        cloud_vars[cloud] = cloud_data["vars"]

        for team in teams:
            cloud_hosts[cloud][team] = dict()

            if team in cloud_children:
                cloud_hosts[cloud][team] = {
                    host: {} for host in cloud_children[team]["hosts"]
                }

    other_hosts = dict()

    try:
        with open("other.yaml", "r") as f:
            other_hosts = yaml.safe_load(f)
    except OSError:
        print("Cannot read other.yaml. No other hosts will be added to inventory.")

    inventory = {
        "all": {
            "children": {
                "globalnoc": {
                    "children": {
                        "bastion": {
                            "children": {
                                "bastion_grnoc": {
                                    "hosts": {
                                        "skip.grnoc.iu.edu": {},
                                        "leap.grnoc.iu.edu": {},
                                        "jump.grnoc.iu.edu": {},
                                    }
                                },
                                "bastion_i2": {
                                    "hosts": {
                                        "bastion.bldc.net.internet2.edu": {},
                                        "bastion.wash2.net.internet2.edu": {},
                                    }
                                },
                                "bastion_nwave": {
                                    "hosts": {
                                        "bastion.bldc.nwave.noaa.gov": {},
                                        "bastion.ctc.nwave.noaa.gov": {},
                                        "bastion.boul.nwave.noaa.gov": {},
                                    }
                                },
                                "bastion_scinet": {
                                    "hosts": {
                                        "bastion.bldc.scinet.usda.gov": {},
                                        "bastion.wash2.scinet.usda.gov": {},
                                    }
                                },
                            },
                            "vars": {
                                "ansible_connection": "local",
                            },
                        }
                    }
                },
                "other": other_hosts,
            }
        }
    }

    globalnoc_hosts = inventory["all"]["children"]["globalnoc"]["children"]
    cloud_group_hosts = dict()

    for cloud in clouds:
        # create cloud category under globalnoc hosts
        cloud_group_hosts[cloud] = {}

        globalnoc_hosts[cloud] = {
            "hosts": dict(),
            "vars": cloud_vars[cloud],
        }

        cloud_team_list = []

        # add each team under the cloud in globalnoc hosts
        for team in teams:
            team_host_list = cloud_hosts[cloud][team].keys()
            cloud_team_list.extend(team_host_list)

            for group in groups:
                if group not in cloud_group_hosts[cloud]:
                    cloud_group_hosts[cloud][group] = []

                if group not in globalnoc_hosts:
                    globalnoc_hosts[group] = {"children": dict()}

                group_hosts = [
                    host
                    for host in team_host_list
                    if re.match(groups[group]["regex"], host)
                ]

                if cloud in groups[group]:
                    # handle add/remove hosts that don't fit the regex
                    group_hosts.extend(
                        [host for host in groups[group][cloud].get("add", [])]
                    )

                    group_hosts = [
                        host
                        for host in group_hosts
                        if host not in groups[group][cloud].get("remove", [])
                    ]

                cloud_group_hosts[cloud][group].extend(group_hosts)

        for group in groups:
            globalnoc_hosts[group]["children"][f"{group}_{cloud}"] = {
                "hosts": {host: dict() for host in cloud_group_hosts[cloud][group]}
            }

        globalnoc_hosts[cloud]["hosts"] = {host: {} for host in cloud_team_list}

    try:
        with open("hosts.yaml", "w") as f:
            yaml.safe_dump(inventory, f)
    except OSError:
        print("Error writing to inventory/hosts.yaml file", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
