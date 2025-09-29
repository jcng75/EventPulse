# S5 - Secure Static Simple Storage Service

### Created and Written By - Justin Ng
### Started: September 12, 2025
### Completed: TBD

# Process Documentation

## Initial Improvements
In my previous project [s5](https://github.com/jcng75/s5), I was not satisfied with the way that the backend configuration was setup.  Doing some research, I found that optimizations could be made using a `backend.conf` file.  Shown in the [README.md](../../README.md), the state file can be initialized referencing the created file.  Additionally, I added a `terraform.tfvars` file, allowing values to be customized outside the created terraform code.  Both files are limited to the user, as they were included within the `.gitignore` file.
