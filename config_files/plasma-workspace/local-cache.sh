# Keep memory-mapped/SQLite-WAL data on local disk instead of the NFS home.
# Sharing these across hosts over NFS causes SIGBUS crashes in plasmashell.

# Create or validate a directory in /var/tmp owned by this user (not a symlink).
_local_dir() {
    [ -e "$1" ] || mkdir -m 700 "$1" 2>/dev/null
    [ -d "$1" ] && [ ! -L "$1" ] && [ -O "$1" ]
}

# 1. Cache
_cache="/var/tmp/xdg-cache-${USER}"
if _local_dir "$_cache"; then
    export XDG_CACHE_HOME="$_cache"
fi

# 2. Per-host SQLite (WAL) data, via symlinks from the NFS home
_local="/var/tmp/xdg-local-${USER}"
if _local_dir "$_local"; then
    for _rel in klipper kactivitymanagerd/resources; do
        _link="$HOME/.local/share/$_rel"
        _target="$_local/$(printf '%s' "$_rel" | tr / _)"
        mkdir -p -m 700 "$_target"
        mkdir -p "$(dirname "$_link")"
        # First run: move the shared NFS copy aside, then link
        if [ -d "$_link" ] && [ ! -L "$_link" ]; then
            mv "$_link" "$_link.nfs-old.$(date +%s)"
        fi
        [ -e "$_link" ] || [ -L "$_link" ] || ln -s "$_target" "$_link"
    done
fi

unset _cache _local _rel _link _target
unset -f _local_dir
