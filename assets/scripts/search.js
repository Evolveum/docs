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

            console.log(json[0].title.toLowerCase().replace(/\s/g, "") + json.length)

            var showItems = [];

            for (var i = 0; i < json.length; i++) {
                if (json[i].title !== undefined && json[i].title.toLowerCase().replace(/\s/g, "").includes(searchedValue)) {
                    console.log("somtu");
                    showItems.push('<a href=https://docs.evolveum.com/' + json[i].url + '>' + '<li>' + json[i].title + '</li>' + '</a>')
                }
            }

            suggBox.innerHTML = showItems.join("")
            console.log(showItems)
        });

    } else {
        suggBox.innerHTML = ""
    }

}