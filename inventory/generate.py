import sys

import yaml

aliases_config = """---
grnoc:
    build.grnoc.iu.edu: {}
    puppet.grnoc.iu.edu: {}
    sandbox.grnoc.iu.edu: {}
nwave:
    puppet7.nwave.noaa.gov: {}
"""

inventory_config = """---
all:
    children:
        globalnoc:
            children:
                bastion:
                    children:
                        bastion_grnoc:
                            hosts:
                                skip.grnoc.iu.edu: {}
                                leap.grnoc.iu.edu: {}
                                jump.grnoc.iu.edu: {}

                        bastion_i2:
                            hosts:
                                bastion.bldc.net.internet2.edu: {}
                                bastion.ctc.net.internet2.edu: {}

                        bastion_nwave:
                            hosts:
                                bastion.bldc.nwave.noaa.gov: {}
                                bastion.ctc.nwave.noaa.gov: {}
                                bastion.boul.nwave.noaa.gov: {}

                        bastion_scinet:
                            hosts:
                                bastion.bldc.scinet.usda.gov: {}
                                bastion.ctc.scinet.usda.gov: {}
"""


def main():
    clouds = ["grnoc", "i2", "nwave", "scinet"]
    teams = ["ics", "mis", "nac", "sea", "sms", "unknown"]

    aliases = yaml.safe_load(aliases_config)
    inventory = yaml.safe_load(inventory_config)

    for cloud in clouds:
        filename = f"upstream/{cloud}.yaml"

        try:
            with open(filename, "r") as f:
                data = yaml.safe_load(f)
        except OSError:
            print(f"Unable to open inventory file {filename}", file=sys.stderr)
            sys.exit(1)

        inventory["all"]["children"]["globalnoc"]["children"][cloud] = {}
        globalnoc_cloud = inventory["all"]["children"]["globalnoc"]["children"][cloud]

        globalnoc_cloud["hosts"] = {
            host: {}
            for team in teams
            for host in data["all"]["children"].get(team, {}).get("hosts", {}).keys()
        }
        globalnoc_cloud["hosts"].update(aliases.get(cloud, {}))

    try:
        with open("globalnoc.yaml", "w") as f:
            yaml.safe_dump(inventory, f)
    except OSError:
        print("Error writing to inventory/hosts.yaml file", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
