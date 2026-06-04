# 認証は GITHUB_TOKEN env var を使う（provider block には token を焼かない）。
#   export GITHUB_TOKEN=$(gh auth token)
# 詳細は infra/README.md を参照。
provider "github" {
  owner = "hskn-dev"
}
