if [ -f /usr/local/share/zsh/site-functions/_aws ]; then
  . /usr/local/share/zsh/site-functions/_aws
fi

for file in ~/.{ah_profile,alias,zacquia,zalias,zfunction,zexports,zopts,zpath,zprivate,zstyle}; do
  [[ -r "$file" ]] && [[ -f "$file" ]] && . "$file"
done
