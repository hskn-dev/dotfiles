# 既存リポジトリを Terraform 管理下に置く。
# 初回は import が必須:
#   terraform import github_repository.dotfiles dotfiles
# import 後に `terraform plan` を実行し、意図せぬ上書きが出ないよう
# description / visibility などの属性を現状値に合わせること。
resource "github_repository" "dotfiles" {
  name       = "dotfiles"
  visibility = "public"

  # 既存のリポ機能フラグ。未記載だと provider のデフォルト適用で
  # 既存値を無効化する差分（true -> null）が出るため、現状(true)を明示して維持する。
  # has_downloads / has_wiki は provider 上 deprecated 警告が出るが、現状維持のため残す。
  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  # マージ済みの head ブランチを自動削除する。
  # main / develop は常に base 側なので削除されず残る。
  delete_branch_on_merge = true
}

# main ブランチ保護（Repository Ruleset / GitHub 推奨の新方式）。
# 内容: PR 経由必須 / 承認は不要(0) / force push 禁止 / ブランチ削除禁止。
resource "github_repository_ruleset" "main" {
  name        = "main-protection"
  repository  = github_repository.dotfiles.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      # default branch(main) を指す特殊参照。
      # 将来 develop も保護するなら include に "refs/heads/develop" を足すか
      # 別 ruleset を追加する。
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    # ブランチ削除を禁止
    deletion = true

    # force push（non-fast-forward）を禁止
    non_fast_forward = true

    # PR 経由を必須にする。承認必須数は 0（個人リポなので self-merge 可）。
    pull_request {
      required_approving_review_count = 0
    }
  }
}
