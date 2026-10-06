# Shared by compose and tags; sourced, never run.

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

# The workspace holding the repository at $1: the outermost GitScale root
# containing it. A clone is its own.
workspace_of() {
    local top next
    top=$(git -C "$1" rev-parse --show-toplevel) || return 1
    while next=$(git -C "$top/.." rev-parse --show-toplevel 2>/dev/null) &&
        [ -f "$next/.gitscale.toml" ]; do
        top=$next
    done
    printf '%s\n' "$top"
}

# The NAME in GITSCALE_DEMO_<NAME>_DIR for the repository at $1: its name
# without gitscale-demo-, upper case, - as _.
name_of() {
    local url base
    url=$(git -C "$1" remote get-url origin 2>/dev/null) || url=$1
    base=$(basename "${url%.git}")
    base=${base#gitscale-demo-}
    base=${base^^}
    printf '%s\n' "${base//-/_}"
}

# `git scale ls --format json` of the workspace $1.
workspace_ls() {
    git -C "$1" scale ls --format json
}

# The topic the workspace is on, from its ls JSON in $1; empty on a pinned
# branch.
topic_of() {
    jq -r 'map(select((.topic | type) == "string"))[0].topic // empty' <<<"$1"
}
