local worktree_ok, worktree = pcall(require, "git-worktree")

if worktree_ok then
  worktree.setup()
  pcall(require("telescope").load_extension("git_worktree"))
end
