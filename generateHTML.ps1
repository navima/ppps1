$merged = cat .\merged.csv

[string] $mydataStr = $merged -replace '^', '[' -replace '$', '],' -replace ',,', ',"",' -replace ',,', ',"",' -replace ',]', ',""]'
$mydataStr = $mydataStr.TrimEnd(',')
$mydataStr = $mydataStr.Insert(0, '[') + "]"

$csv = Import-Csv .\merged.csv

[string[]] $checkboxMarkups = @()

$csv | % { $i = 1 } {
    $name = $_.Name
    $members = $_ | Get-Member -MemberType NoteProperty
    $lastPricePropName = $members[$members.length - 2].Name
    $lastprice = $_ | Select-Object -ExpandProperty $lastPricePropName
    $checkboxMarkups += @"
<tr>
    <td> <input type="checkbox" id="$i" class="checkbox" onclick="doHide(this)" >
    <td> <label for="$i">$name</label>
    <td> $lastprice
</tr>

"@

    $i++
}



$html = @"
<link rel="stylesheet" href="index.css">
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
google.charts.load('current', { 'packages': ['corechart'] });
google.charts.setOnLoadCallback(drawChart);


var options = {
    legend: { position: 'bottom' },
    interpolateNulls: false
};

var tada
var chart

function getShown() {
    var showids = [0]
    var shown = document.getElementsByClassName("checkbox")
    for (let i = 0; i < shown.length; i++) {
        const element = shown[i];
        if (element.checked) {
            showids[showids.length] = parseInt(element.id)
        }
    }

    return showids
}

function doHide(sender) {
    //shown[sender.id] = !shown[sender.id]
    console.log(getShown())
    tada.setColumns(getShown())
    chart.draw(tada, options);
    //this.checked = shown[sender.id]
}


function transposeDataTable(dataTable) {
    //step 1: let us get what the columns would be
    var rows = [];//the row tip becomes the column header and the rest become
    for (var rowIdx = 0; rowIdx < dataTable.getNumberOfRows(); rowIdx++) {
        var rowData = [];
        for (var colIdx = 0; colIdx < dataTable.getNumberOfColumns(); colIdx++) {
            rowData.push(dataTable.getValue(rowIdx, colIdx));
        }
        rows.push(rowData);
    }
    var newTB = new google.visualization.DataTable();
    newTB.addColumn('string', dataTable.getColumnLabel(0));
    newTB.addRows(dataTable.getNumberOfColumns() - 1);
    var colIdx = 1;
    for (var idx = 0; idx < (dataTable.getNumberOfColumns() - 1); idx++) {
        var colLabel = dataTable.getColumnLabel(colIdx);
        newTB.setValue(idx, 0, colLabel);
        colIdx++;
    }
    for (var i = 0; i < rows.length; i++) {
        var rowData = rows[i];
        console.log(rowData[0]);
        newTB.addColumn('number', rowData[0]); //assuming the first one is always a header
        var localRowIdx = 0;

        for (var j = 1; j < rowData.length; j++) {
            newTB.setValue(localRowIdx, (i + 1), rowData[j]);
            localRowIdx++;
        }
    }
    return newTB;
}

function drawChart() {

    var data = transposeDataTable(google.visualization.arrayToDataTable([["Name","2021-01-02","2021-01-03","2021-01-06","2021-01-09","2021-01-12","2021-01-15","2021-01-16","2021-01-18","2021-01-19"], ["210","13630","13630","13630","13590","13580","12170","12120","12030","12070"], ["gt-1030","25380","25380","25230","25100","25320","24390","24990","24990","24990"], ["gt-710","12020","12020","11490","11610","11930","12000","11840","12000","11900"], ["gt-730","18990","20080","19640","19400","19850","19780","19780","20080","19880"], ["gtx-1050","54990","54990","51480","41815","54990","54990","54730","54990","54780"], ["gtx-1050-ti","49199","49199","55190","56990","58990","51275","58990","61631","58558"], ["gtx-1060","179924","179924","90330","179924","179924","174701","174701","174701","174701"], ["gtx-1070","179990","179990","179990","179990","179990","","","",""], ["gtx-1650","52990","59900","59900","57900","57900","66990","67380","71600","73000"], ["gtx-1650-super","65900","65900","65900","65900","65900","134946","133789","133789","133789"], ["gtx-1660","89990","89990","89990","76900","76900","","139900","124990",""], ["gtx-1660-super","91900","91900","91900","110900","110900","99140","149990","134990","163340"], ["gtx-1660-ti","112070","112070","128990","118140","118140","119322","118140","118140","118140"], ["p1000","117296","116107","115460","114370","117900","115912","115912","121000","121000"], ["p2000","173580","173580","170980","170880","170150","170580","168010","170150","168450"], ["p2200","168420","168376","165890","165771","164440","168530","164440","165740","164080"], ["p4000","303070","303070","298520","298409","298409","274900","274900","274900","274900"], ["p620","70450","70450","70450","69880","72320","64654","64642","64699","64699"], ["r7-240","26420","26420","25780","25780","26160","27840","27420","27840","27560"], ["rtx-2060","135900","135900","135900","135900","135900","","","",""], ["rtx-2070-super","","","","","","","","",""], ["rtx-2080-super","242820","242820","242820","242820","242820","","","",""], ["rtx-2080-ti","499990","499990","499990","499990","499990","399990","399990","499990","507900"], ["rtx-3060-ti","256990","256990","256990","239990","269990","299990","355990","","289000"], ["rtx-3070","293990","293990","257590","278240","299000","304990","309990","344990","355670"], ["rtx-3080","447990","447990","470056","409990","489990","","529990","529990","529990"], ["rtx-3090","641390","641390","641390","649786","735330","735330","643306","771990","788916"], ["rtx-4000","339049","336027","339049","336027","336027","336027","337000","338000","345280"], ["rtx-5000","786520","786520","774720","774720","786520","786520","774720","786520","778650"], ["rtx-6000","1800749","1800749","1779913","1733180","1778398","1772368","1746990","1772024","1754300"], ["rtx-8000","","","","2064090","","","2078080","","2080020"], ["rx-550","26190","27150","22290","28470","28900","29630","29620","29520","29410"], ["rx-5500-xt","76590","76590","76590","76590","76590","","109440","85500","158750"], ["rx-5600","157350","157350","157790","191880","177000","177000","","227660","227660"], ["rx-5600-xt","131690","131690","131690","131690","131690","","172500","",""], ["rx-570","65400","65400","64880","63900","63900","","126760","126760","72800"], ["rx-5700","145900","145900","145900","145900","145900","","","",""], ["rx-5700-xt","199900","199900","199000","162900","266680","","","327699","327699"], ["rx-580","77990","77990","81990","110840","110990","","128790","153471","141790"], ["rx-6800","416090","416090","415460","389900","389900","435900","389900","389900","389900"], ["rx-vega-56","161710","161710","161710","161710","","","","",""], ["wx-2100","55190","55190","54990","52490","52780","52790","52790","52790","52790"], ["wx-3100","68090","68090","67790","67190","67490","67490","67490","79190","79190"], ["wx-3200","71250","71250","71250","67090","67390","69780","71610","72100","72100"], ["wx-4100","106990","106990","106990","102990","103990","103990","103990","103990","103990"], ["wx-5100","152280","152280","152280","152280","152230","153630","146490","146790","146790"], ["wx-7100","","","","","285013","427566","283986","284239","284239"], ["wx-8200","401890","401890","401890","399720","394310","401900","403680","403680","407340"]]))

    tada = new google.visualization.DataView(data)
    tada.setColumns(getShown())

    chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

    chart.draw(tada, options);
}
</script>

<div id="curve_chart" class="chart"></div>

<table>
    <thead>
        <tr>
            <td>
            <td>Name
            <td>Price
            <td>Performance
            <td>PpP
        </tr>
    </thead>

    <tbody>
        $checkboxMarkups
    </tbody>
</table>
"@

$html > index.html