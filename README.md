prospectus_terraform
=========

[![Gem Version](https://img.shields.io/gem/v/prospectus_terraform.svg)](https://rubygems.org/gems/prospectus_terraform)
[![Build Status](https://img.shields.io/travis/com/akerl/prospectus_terraform.svg)](https://travis-ci.com/akerl/prospectus_terraform)
[![Coverage Status](https://img.shields.io/codecov/c/github/akerl/prospectus_terraform.svg)](https://codecov.io/github/akerl/prospectus_terraform)
[![Code Quality](https://img.shields.io/codacy/c5623564a4034ece993510d28edb19de.svg)](https://www.codacy.com/app/akerl/prospectus_terraform)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

[Prospectus](https://github.com/akerl/prospectus) helpers for Terraform repos

## Usage

Add the following 2 lines to the .prospectus:

```
## Add this at the top
Prospectus.extra_dep('file', 'prospectus_terraform')

## Add this inside your terraform repo to check for provider updates
extend ProspectusTerraform.new
```

If some of your providers have a custom Github Repo, you can set it by adding a comment in the main.tf in their section as shown:

```
provider "awscreds" {
  // provider.awscreds akerl/terraform-provider-awscreds
  version = "0.0.5"
  region  = "us-east-1"
}
```

## Installation

    gem install prospectus_terraform

## License

prospectus_terraform is released under the MIT License. See the bundled LICENSE file for details.

