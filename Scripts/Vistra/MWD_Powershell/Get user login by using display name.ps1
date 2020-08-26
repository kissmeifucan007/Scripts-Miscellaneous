#1
$Names = @(
"Iveta Dobrudzhalieva"
)
#lub
$a = @"
Michael Walton
Yvonne Cole-Huber
Paulo Alves Adao
Elio Castellano
Ruhua Wang
Sandra Jankowski
Dylan De Abreu
Aymeric Cenne
Dilyana Panayotova
Andrzej Klapinski
Christophe De Oliveira
Pravesh Poonyth
Aymeric Cenne
Frédéric Beck
Marie-Laure Masuy
Maria Teresa Lopez
Fatih Ablak
Amod Vashisht
Caroline McCaffery
Kevin Deom
Athanasia Kalli
Simon Dueholm
Laurent Ley
Nyana Ficot
Martin Milosevic
Erkin Usupov
Gertjan Kurpershoek
Alana Whelan
An-An Shong
Maria Hazasova
Rasmus Brandstrup
Tao Perrin
Sandra Osorio
Claire Theobald
Camelia Ciocarlan
Clement Strassel
Alexander Vargas
Sonia Kulpman
Brian Goepp
Marion Raabe
Nicolas Boyer
Nicolai Von Den Benken
Thierry Delgorgue
Orhan Aksoz
Monya Mansouri
Stavros Matthaiou
"@
$names = $a.Split([Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)


2#
$table = @()
foreach ($Name in $Names){
$NTName = $null
$Searcher = [ADSISearcher]"(&(objectCategory=person)(objectClass=user)(cn=$Name))"
[void]$Searcher.PropertiesToLoad.Add("sAMAccountName")
$Results = $Searcher.FindAll()
ForEach ($User In $Results)
{
    $NTName = $User.Properties.Item("sAMAccountName")
    $NTName
}
$info = [pscustomobject]@{
usefullname = $Name
login=$NTName
}
$table += $info
}
$table | Out-GridView
