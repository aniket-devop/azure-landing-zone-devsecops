location = "centralindia"

# Add a workload by adding an entry. Review the plan in the pull request.
spokes = {
  corp-app1 = {
    workload_type = "corp"
    address_space = ["10.1.0.0/24"]
    subnets = {
      app  = "10.1.0.0/26"
      data = "10.1.0.64/26"
    }
  }
}

tags = {
  owner       = "app1-team"
  environment = "dev"
  cost-center = "it-002"
}
