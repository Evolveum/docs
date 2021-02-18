/*
 * This script looks for pages that contain given phrase.
 *
 * It load titles and other info from https://docs.evolveum.com/searchmap.json
 *
 * It works like this:
 *
 * This script lists all pages in searchmap.json.
 *
 * 1. If a page has identical title with the given phrase, it will have the top priority in the list of suggestions.
 * 2. If a page has a key word identical to the searched phrase, it will have the second priority.
 * 3. If its title contains given phrase, it will have the third priority.
 * 4. Everything else will have the lowest priority.
 *
 * When the pages are sorted, the script will get first 5 pages and display them in the suggestion bar.
 *
 * User input is not case sensitive.
 */

const LIMIT_OF_PAGES_SHOWN = 5;

function searchForPhrase() {

    const suggestionBox = document.getElementById("autocombox")

    const phrase = document.getElementById('searchbar2').value.toLowerCase()

    if (phrase !== "") {
        console.log("Searched phrase: " + phrase)

        // later we will cache the JSON searchmap
        $.getJSON("/searchmap.json", function(searchMap) {

            const showItemsTitleMatch = [] // pages whose titles are the same as searched phrase
            const showItemsKeyWordMatch = [] // pages whose some key word is same as searched phrase
            const showItemsTitleSubstringMatch = [] // pages whose titles contain searched phrase
            const showItemsOther = [] // all other pages that somewhere contain searched phrase
            const showItems = [] // list of top suggestions for user

            let numberOfNotShown = 0 // number of pages not shown to the user because of limit

            for (let i = 0; i < searchMap.length; i++) {
                if (searchMap[i].title !== undefined) {

                    // combines all the data from searchMap entry
                    let allTextWithoutWS = normalize(searchMap[i].title)

                    if (searchMap[i].description !== undefined) {
                        allTextWithoutWS += ' ' + normalize(searchMap[i].description)
                    }

                    if (searchMap[i].author !== undefined) {
                        allTextWithoutWS += ' ' + normalize(searchMap[i].author)
                    }

                    if (searchMap[i].keyWords !== undefined) {
                        allTextWithoutWS += ' ' + normalize(searchMap[i].keyWords)

                        // array of single words in keywords item - to be matched with the phrase
                        // TODO implement searching for two words as a phrase
                        var keyWords = searchMap[i].keyWords.replace(/,/g, '').split(' ')
                    }

                    // If allTextWithoutWS does not include the phrase, it is useless to check for
                    // more specific matches, like title match or keywords match.
                    if (allTextWithoutWS.includes(normalize(phrase))) {
                        const title = searchMap[i].title.toLowerCase()

                        console.log(title);

                        const listItem = '<a href=https://docs.evolveum.com/' + searchMap[i].url + '>' +
                                '<li class="list-group-item"><span class="font1">' + searchMap[i].title + '<br></span>' +
                                '<span class="font2">' + formatDate(searchMap[i].lastModificationDate) + '</span></li></a>'
                        if (title.localeCompare(phrase) === 0) {
                            console.log('input is title')
                            showItemsTitleMatch.push(listItem)
                        } else if (keyWords !== undefined && keyWords.includes(phrase)) {
                            showItemsKeyWordMatch.push(listItem)
                        } else if (title.includes(phrase)) {
                            console.log('input is substring')
                            showItemsTitleSubstringMatch.push(listItem)
                        } else {
                            showItemsOther.push(listItem)
                        }
                    }
                }
            }

            for (let arr of[showItemsTitleMatch, showItemsKeyWordMatch, showItemsTitleSubstringMatch, showItemsOther]) {
                let i
                for (i = 0; i < arr.length && showItems.length < LIMIT_OF_PAGES_SHOWN; i++) {
                    showItems.push(arr[i]);
                }
                console.log(showItems)
                numberOfNotShown += arr.length - i
            }

            console.log('not shown ' + numberOfNotShown)

            if (numberOfNotShown === 1) {
                showItems.push('<li class="notShown"> additional ' + numberOfNotShown + ' result not shown' + '</li>')
            } else if (numberOfNotShown > 0) {
                showItems.push('<li class="notShown"> additional ' + numberOfNotShown + ' results not shown' + '</li>')
            }

            suggestionBox.innerHTML = showItems.join("")
            suggestionBox.style.display = "table";
        });

    } else {
        suggestionBox.innerHTML = ""
        suggestionBox.style.display = "none";
    }
}


// converts date and time into date
function formatDate(dateAndTime) {
    return dateAndTime?.replace(/T.+/g, " ") // Will be improved later.
}

function normalize(text) {
    return text.toLowerCase().replace(/\s/g, "")
}
