# infra — リポジトリ設定の Terraform 管理

`hskn-dev/dotfiles` の GitHub 設定を IaC（Terraform + `integrations/github` provider）で
管理する。

## 管理対象

| リソース | 内容 |
|---|---|
| `github_repository.dotfiles` | `delete_branch_on_merge = true`（マージ済み head ブランチの自動削除） |
| `github_repository_ruleset.main` | `main` 保護：PR 必須 / 承認 0 / force push 禁止 / 削除禁止 |

`main` / `develop` は PR の base 側なので、自動削除の対象外（残る）。

## 認証（PAT）

provider は `GITHUB_TOKEN` env var を認証情報として読む。`provider` block に
token は書かない。

```bash
# 方法1: gh CLI の token を流用（手元での運用）
export GITHUB_TOKEN=$(gh auth token)

# 方法2: PAT を発行して使う（CI や権限を絞りたい場合）
#   GitHub > Settings > Developer settings > Personal access tokens
#   必要スコープ: repo（Repository Ruleset の操作に repo admin 権限が必要）
export GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
```

> `gh auth token`（OAuth token）で 403 になる場合は repo admin 権限が不足している。
> その場合は方法2 で `repo` スコープの PAT を発行する。

## 手順

state はローカル（`infra/terraform.tfstate`）で運用する。リモート backend は必要に
なってから導入する。state ファイルは `.gitignore` 済みでコミットしない。

```bash
cd infra
export GITHUB_TOKEN=$(gh auth token)

# 初期化
terraform init

# 既存リポを管理下に取り込む（初回のみ）
terraform import github_repository.dotfiles dotfiles

# 差分確認 → 適用
terraform plan
terraform apply
```

### 初回 import の注意

`github_repository` は既存リポを表すため、`import` してから `plan` を実行し、
`description` / `visibility` などが現状と一致しているか確認する。差分が出たら
`main.tf` の属性を現状値に合わせ、`delete_branch_on_merge` の変更と ruleset の
追加だけが差分になる状態にしてから `apply` する。
