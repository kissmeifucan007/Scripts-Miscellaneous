# Get all adgroups with name starting with "DM*"
$groups = get-adgroup -filter {name -like "DM*"}
# Select base path from each group by
# 1. splitting by comma
# 2. skipping first element (group name)
# 3. joining paths again
# 4. selecting only unique elements:
$groups | foreach {(($_ -split ',') | skip 1) -join ','} | select -Unique | Out-GridView -Title "DM Security group OUs"