return {
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({
        windowCreationCommand = "botright vnew",
        window = {
          width = 0.25,
        },
      })
    end,
  },
}
