$PlaylistURL = $args[0]

. "$PSScriptRoot\functions.ps1"

Get-PlaylistTracks -PlaylistURL $PlaylistURL | ConvertTo-Json