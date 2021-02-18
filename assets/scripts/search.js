//var text = ""
// while (document.getElementById('search').value != null && document.getElementById('search').value.equals(text)) {
//
// }

function searchA() {
    // var suggBoxes = document.getElementsByClassName("autocom-box");
    // console.log("dlzka " + suggBoxes.length)
    //var suggBox = suggBoxes[0];
    var suggBox = document.getElementById("autocombox")

    var searchedValue = document.getElementById('searchbar2').value.toLowerCase().replace(/\s/g, "")

    if (searchedValue != "") {
        console.log(searchedValue)

        $.getJSON("/searchmap.json", function(json) {
            console.log(json); // this will show the info it in firebug console
            var data = JSON.parse(json)

            console.log(data[0].title.toLowerCase().replace(/\s/g, "") + data.length)

            var showItems = [];

            for (var i = 0; i < data.length; i++) {
                if (data[i].title !== undefined && data[i].title.toLowerCase().replace(/\s/g, "").includes(searchedValue)) {
                    console.log("somtu");
                    showItems.push('<a href=https://docs.evolveum.com/' + data[i].url + '>' + '<li>' + data[i].title + '</li>' + '</a>')
                }
            }

            suggBox.innerHTML = showItems.join("")
            console.log(showItems)
        });

    } else {
        suggBox.innerHTML = ""
    }

    //neskor
    //let url = 'https://docs.evolveum.com/searchmap.json';
    // $.getJSON(url, {

    // }).done(function(data) {
    //     console.log("halo" + url)
    // });

}