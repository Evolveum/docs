/*
 * This script search titles that contains searched phrase.
 *
 * It load titles and info from https://docs.evolveum.com/searchmap.json
 * 
 * It works like this:
 * 
 * This script list all titles and when they contains what user had typed into searchbar it will push it to array. If array has more than 10 possible titles it wont add another titles.
 * User input is not case sensitive.
 */

function searchA() {

    var suggBox = document.getElementById("autocombox")

    var searchedValue = document.getElementById('searchbar2').value.toLowerCase().replace(/\s/g, "")

    if (searchedValue != "") {
        console.log("Searched phrase" + searchedValue)

        $.getJSON("/searchmap.json", function(json) {
            //console.log(json);

            //console.log(json[0].title.toLowerCase().replace(/\s/g, "") + json.length)

            var showItems = [];

            for (var i = 0; i < json.length; i++) {
                if (json[i].title !== undefined && json[i].title.toLowerCase().replace(/\s/g, "").includes(searchedValue)) {
                    //console.log("somtu");
                    if (showItems.length < 11) {
                        showItems.push('<a href=https://docs.evolveum.com/' + json[i].url + '>' + '<li>' + json[i].title + '\n' + json[i].lastModificationDate + '</li>' + '</a>')
                    }

                }
            }

            suggBox.innerHTML = showItems.join("")
                //console.log(showItems)
        });

    } else {
        suggBox.innerHTML = ""
    }

}