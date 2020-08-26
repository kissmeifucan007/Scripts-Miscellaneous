Enum DiceHits
{
 Black = 1
 Red = 2
 PreventBlack = 3
 PreventRed = 4
 Any = -1
 No = 0
}

Enum DiceColors
{
Red   = 0
Black = 1
Green = 2
}


class Die {
[ValidateNotNullOrEmpty()][DiceHits[]] $Hits
[ValidateNotNullOrEmpty()][DiceColors] $Color
   Die([DiceHits[]]$Hits,[DiceColors]$Color){
       $this.Hits = $Hits
       $this.Color = $color
   }
  static [int[]] $currentResult = 0,0,0 
  static [int[]] $preventedHits = 0,0,0


   Roll(){
      $number = get-random -Minimum 1 -Maximum 6
      $this.Hits[$number]     
   }  

   }
   <#
   }
      $roll = get-random -Minimum 1 -Maximum 6
      $black = 0
      $red   = 0
      $preventBlack = 0
      $preventRed = 0
      $any   = 0
      switch ($this.Hits[$roll]){
          Black {$black++}
          Red {$red++}
          PreventBlack {$preventBlack++}
          PreventRed {$preventRed++}
          Any {$any++}
          Default {}
      } 
   
   }

   ResetRolls(){
      [Die]::currentResult = 0,0,0
   }

   DisplayRolls(){
      Write-Host -ForegroundColor Black "Black hitpoints: [Die]::currentResult[0]"
      Write-Host -ForegroundColor Red "Red hitpoints: [Die]::currentResult[0]"
      Write-Host -ForegroundColor Green "Green (hitpoints of choice): [Die]::currentResult[0]"
   }
}
#>

class Roller{
  static  [Die]$blackDie = [Die]::new(@([DiceHits]::Black,[DiceHits]::Black,[DiceHits]::Any,[DiceHits]::Black2,[DiceHits]::No,[DiceHits]::No))
  static  [Die]$redDie   = [Die]::new(@([DiceHits]::Red,[DiceHits]::Red,[DiceHits]::Any,[DiceHits]::Red2,[DiceHits]::No,[DiceHits]::No)) 
  static  [Die]$greenDie = [Die]::new(@([DiceHits]::Any,[DiceHits]::Any,[DiceHits]::No,[DiceHits]::No,[DiceHits]::No,[DiceHits]::No))

  static Roll ([DiceColors]$color){
     switch ($color){
        Black {[Roller]::blackDie.Roll()}
        Red {[Roller]::redDie.Roll()}
        Green {[Roller]::greenDie.Roll()}
     }
  }
}

[Roller]::Roll([DiceColors]::Black)


$blackRolls = 4
$redRolls = 2
$greenRolls = 4

for ($i =0; $i -le $blackRolls; $i++){
   $blackDie.Roll()
}
for ($i =0; $i -le $redRolls; $i++){
   $redDie.Roll()
}
for ($i =0; $i -le $greenRolls; $i++){
   $greenDie.Roll()
}

[Die]::currentResult
