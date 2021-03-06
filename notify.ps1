param (
    [string]$MAILGUN_API_KEY = '',
    $csv_file = ''
)

echo $csv_file

$csv = Import-Csv $csv_file
$prices = @{}
$csv | % {
    $prices.Add($_.Name, $_.Value)
}

$watcherlist = cat watch.json | ConvertFrom-Json 

$watcherlist | % {
    $watcher_addr = $_.address
    $watchlist = $_.watchlist
    
    $text

    $watchlist | % {
        $Name = $_.product
        [int]$Value = $_.price

        [int]$actualprice = $prices[$Name]
        if ($prices.ContainsKey($Name) -and $actualprice -lt $Value -and $actualprice -ne 0) {
            $text += "$Name for $actualprice (<$Value)
            "
        }
    }

    if (-not $text -eq '') {
        curl --user "api:$MAILGUN_API_KEY" https://api.eu.mailgun.net/v3/vikt0r.eu/messages -F from='Scraper <Scraper@vikt0r.eu>' -F to="$watcher_addr" -F subject='Watch notification' -F text="$text"
    }
}
