# common configuration
location = "eu-iceland1-a"
project_id = "9c75db17-61c6-44e0-98e9-53a5689d9ff7"
ssh_public_key_path = "~/.ssh/crusoe-dx-lab.pub"
vpc_subnet_id = "7fea2fae-c316-4f48-8bf7-6627f3f6dd7e"

#GB200 specific variables
enable_imex_support = true

# slurm-compute-node configuration
slurm_compute_node_type = "gb200-186gb-nvl.4x"
slurm_compute_node_count = 16

# observability
enable_observability = true
grafana_admin_password = "admin123"

# # Shared disks using VAST NFS
# use_vast_nfs = false
# vastnfs_version = "4.0.35"

# VAST NFS disk configuration
# slurm_shared_disk_nfs_home_size = "10TiB"
# slurm_data_disk_size = "10TiB"
# slurm_data_disk_mount_path = "/data"

# Use pre-existing Slurm VAST data disk. Will be attached to the login and compute nodes
# pre_existing_slurm_data_disk_id = "40332855-f6ad-4611-a61e-7772a41795ea"


slurm_head_node_count = 1
slurm_login_node_count = 1