A bare repo that stores config files exactly where they should be.

```bash
git clone --bare git@github.com:matharman/dotfiles.git $HOME/.dots
git --git-dir $HOME/.dots --work-tree $HOME checkout
```

