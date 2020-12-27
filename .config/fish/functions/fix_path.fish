#!/usr/local/bin/fish
function fix_path --description "Removes duplicate entries from \$PATH"
  set -l NEWPATH
  for p in $PATH
    if not contains $NEWPATH $p
      # breakpoint
      # printf "NEWPATH:%s\n" $NEWPATH
      # printf "p:%s\n" $p
      set NEWPATH $NEWPATH $p
    end
  end
  set PATH $NEWPATH
end
