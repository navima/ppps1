.\getTypes.ps1 'https://www.arukereso.hu' 'videokartya-c3142' 5 | .\getPrice.ps1 > ("prices-" + (Get-date -format "yyyy-MM-dd") + ".csv")