function Get-OtherCommandsFromModule {
    param(
    [string]$CommandName
    )
    Get-Command $CommandName |% {get-command -Module $_.module}
}

