$users = get-content users.json
$users  = Get-Content -Raw -Path users.json | ConvertFrom-Json
$officesCEE = @("warsaw","wroclaw","poznan","krakow","lublin","sofia","budapest","bucharest","prague","bratislava")
$usersCEE = $users |  where {$_.user_fields.office_new -in $officesCEE} 

$filteredUsers = $usersCEE | select *, @{n="office";e={$_.user_fields.office_new}},@{n="agent_ooo";e={$_.user_fields.agent_ooo}},@{n="agent_team";e={$_.user_fields.agent_team}},@{n="job_title";e={$_.user_fields.job_title}},@{n="timezoneset";e={$_.user_fields.timezoneset}},@{n="username";e={$_.user_fields.username}},@{n="verona";e={$_.verona.verona}}
$filteredUsers | select 


$fields = @"
id
url
name
email
time_zone
iana_time_zone
phone
shared_phone_number
locale_id
locale
organization_id
role
verified
external_id
tags
alias
active
last_login_at
two_factor_auth_enabled
signature
details
notes
role_type
custom_role_id
suspended
default_group_id
office
agent_ooo
agent_team
job_title
username
"@

$fields = $fields.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$csvProperties = @{
    delimiter = ";"
    encoding = "UTF8"
    noTypeInformation = $true
    force = $true
    path = "CEEUsers.csv"
}

$filteredUsers | select $fields | export-csv @csvProperties

$filteredUsers[0]