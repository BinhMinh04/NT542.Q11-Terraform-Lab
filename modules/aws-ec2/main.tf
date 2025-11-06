resource "aws_instance" "main" {
  ami                                  = var.ami
  associate_public_ip_address          = var.associate_public_ip_address
  availability_zone                    = var.availability_zone
  disable_api_stop                     = var.disable_api_stop
  disable_api_termination              = var.disable_api_termination
  ebs_optimized                        = true
  get_password_data                    = var.get_password_data
  hibernation                          = var.hibernation
  host_id                              = var.host_id
  host_resource_group_arn              = var.host_resource_group_arn
  iam_instance_profile                 = var.iam_instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  key_name                             = var.key_name
  monitoring                           = var.monitoring
  placement_group                      = var.placement_group
  placement_partition_number           = var.placement_partition_number
  private_ip                           = var.private_ip
  secondary_private_ips                = var.secondary_private_ips
  source_dest_check                    = var.source_dest_check
  subnet_id                            = var.subnet_id
  tags                                 = var.tags
  tenancy                              = var.tenancy
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  user_data_replace_on_change          = var.user_data_replace_on_change
  volume_tags                          = var.tags
  vpc_security_group_ids               = var.vpc_security_group_ids

  dynamic "cpu_options" {
    for_each = var.cpu_options != null ? [var.cpu_options] : []
    content {
      amd_sev_snp      = cpu_options.value.amd_sev_snp
      core_count       = cpu_options.value.core_count
      threads_per_core = cpu_options.value.threads_per_core
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device != null ? [var.root_block_device] : []
    content {
      delete_on_termination = root_block_device.value.delete_on_termination
      encrypted             = root_block_device.value.encrypted
      iops                  = root_block_device.value.iops
      kms_key_id            = root_block_device.value.kms_key_id
      throughput            = root_block_device.value.throughput
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device != null ? var.ephemeral_block_device : []
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = ephemeral_block_device.value.no_device
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }

  dynamic "maintenance_options" {
    for_each = var.maintenance_options != null ? [var.maintenance_options] : []
    content {
      auto_recovery = maintenance_options.value.auto_recovery
    }
  }

  dynamic "instance_market_options" {
    for_each = var.instance_market_options != null ? [var.instance_market_options] : []
    content {
      market_type = "spot"

      dynamic "spot_options" {
        for_each = instance_market_options.value.spot_options != null ? [instance_market_options.value.spot_options] : []
        content {
          instance_interruption_behavior = spot_options.value.instance_interruption_behavior
          max_price                      = spot_options.value.max_price
          spot_instance_type             = spot_options.value.spot_instance_type
          valid_until                    = spot_options.value.valid_until
        }
      }
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = metadata_options.value.http_endpoint
      http_tokens                 = metadata_options.value.http_tokens
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
      instance_metadata_tags      = metadata_options.value.instance_metadata_tags
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }
}

/*
Currently, changes to the ebs_block_device configuration of existing resources cannot be automatically detected by Terraform. 
To manage changes and attachments of an EBS block to an instance, use the aws_ebs_volume and aws_volume_attachment resources instead.
*/
# Create ebs volume based on map of objects.
resource "aws_ebs_volume" "dependence" {
  for_each = var.ebs_volumes

  availability_zone    = var.availability_zone
  size                 = each.value.size
  encrypted            = true
  final_snapshot       = each.value.final_snapshot
  iops                 = each.value.iops
  multi_attach_enabled = each.value.multi_attach_enabled
  type                 = each.value.type
  kms_key_id           = each.value.kms_key_id
  throughput           = each.value.throughput
  tags                 = each.value.tags
}

# Create volume attachment based on map of objects.
resource "aws_volume_attachment" "this" {
  for_each = aws_ebs_volume.dependence

  device_name                    = each.value.tags["device_name"]
  volume_id                      = each.value.id
  instance_id                    = aws_instance.main.id
  stop_instance_before_detaching = true
}
