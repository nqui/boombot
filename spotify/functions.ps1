function Get-PlaylistID {
    param(
        [Parameter(Mandatory=$True)]
        [String]
        $PlaylistURL
    )
    return ($PlaylistURL -split "/")[-1]
}

function Get-PlaylistInfo {
    param(
        [Parameter(Mandatory=$True)]
        [String]
        $PlaylistURL
    )

    $PlaylistID = Get-PlaylistID -PlaylistURL $PlaylistURL

    $Endpoint = "playlists/$PlaylistID"

    $Payload = @{
        Uri = (Get-BaseUri) + $Endpoint
        Method = "Get"
        Headers = @{
            Authorization="Bearer " + (Get-AccessToken)
        }
    }
    Invoke-RestMethod @Payload
}

function Get-PlaylistTracks {
    param(
        [Parameter(Mandatory=$True)]
        [String]
        $PlaylistURL
    )

    $PlaylistID = Get-PlaylistID -PlaylistURL $PlaylistURL

    $Endpoint = "playlists/$PlaylistID/tracks"

    $Payload = @{
        Uri = (Get-BaseUri) + $Endpoint
        Method = "Get"
        Headers = @{
            Authorization="Bearer " + (Get-AccessToken)
        }
    }
    $Response = Invoke-RestMethod @Payload

    if($Response) {
        Export-PlaylistTracks -PlaylistItems $Response.tracks.items
    }
}

function Export-PlaylistTracks {
    param(
        [Parameter(Mandatory=$True)]
        [PSCustomObject[]]
        $PlaylistItems
    )

    $Output = [System.Collections.Generic.List[PSCustomObject]]::new()

    foreach($Track in $PlaylistItems) { 
        $Object = [PSCustomObject]@{
            Artists = $Track.track.artists.name -join " "
            TrackName = $Track.track.name
            AlbumName = $Track.track.album.name
        }
        $Output.Add($Object)
    }
    return $Output
}