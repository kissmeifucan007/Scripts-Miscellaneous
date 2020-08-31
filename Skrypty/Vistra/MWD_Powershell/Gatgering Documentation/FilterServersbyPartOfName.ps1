$nameStarts = @"
buc
bud
sof
kra
lub
poz
wro
prg
"@

$starts = $nameStarts.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$servers = foreach ($start in $starts){
   $pattern = $start+"srv*"
   get-adcomputer -Server work.local -Filter {name -like $pattern} | select name 
}