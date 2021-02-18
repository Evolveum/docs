/*
 * This script search titles that contain given phrase.
 *
 * It load titles and info from https://docs.evolveum.com/searchmap.json
 *
 * It works like this:
 *
 * This script list all titles and when they contains what user had typed into searchbar it will push it to array.
 * If array has more than 5 possible titles it won't add another title.
 *
 * User input is not case sensitive.
 */

function searchA() {

    var suggBox = document.getElementById("autocombox")

    var searchedValue = document.getElementById('searchbar2').value.toLowerCase().replace(/\s/g, "")

    if (searchedValue != "") {
        console.log("Searched phrase" + searchedValue)

        $.getJSON("/searchmap.json", function(json) {

            var showItems = [];

            var numberOfNotShown = 0;

            for (var i = 0; i < json.length; i++) {
                if (json[i].title !== undefined && json[i].title.toLowerCase().replace(/\s/g, "").includes(searchedValue)) {
                    //console.log("somtu");este
                    if (showItems.length < 5) {
                        showItems.push('<a href=https://docs.evolveum.com/' + json[i].url + '>' + '<li class="searchResult"><span class="font1">' + json[i].title + '<br></span>' + '<span class="font2">' + json[i].lastModificationDate.replace(/\T.+/g, " ") + '</span></li></a>')
                    } else {
                        numberOfNotShown++;
                    }
                }
            }

            console.log('not shown ' + numberOfNotShown)

            if (numberOfNotShown === 1) {
                showItems.push('<li class="notShown"> additional ' + numberOfNotShown + ' result not shown' + '</li>')
            } else if (numberOfNotShown > 0) {
                showItems.push('<li class="notShown"> additional ' + numberOfNotShown + ' results not shown' + '</li>')
            }

            suggBox.innerHTML = showItems.join("")

            suggBox.style.display = "table";
        });

    } else {
        suggBox.innerHTML = ""
        suggBox.style.display = "none";
    }

}