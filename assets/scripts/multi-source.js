/*
 * This script finds groups of code snippets in different languages and turns them into navbars.
 *
 * Groups must fulfill these requiments:
 *      1. Must have more than 1 code snippet.
 *      2. Code snippets must be in divisions with class name "listingblock" (and with specific DOM structure - please see the code).
 *      3. Code snippets must not have other DOM elements between them.
 *      4. Code snippets must be written in different languages.
 *
 * It works like this:
 *
 * This script finds all elements of name "listingsblock". Then it determines if they will be replaced by navbar.
 * If element does not meet some demands, active group will end and if it meet some requirements, it will be replaced with navbar.
 * Arrays will be then reset and script will be finding new group.
 */

var groups = document.getElementsByClassName("listingblock");
var languageNames = []; // Contains names of languages of actual listings.
var codeSnippets = []; // Contains HTML divisions of actual listings.
var repeatedLanguage = false; // True if some language is more than once in a group.

for (var i = 0; i < groups.length; i++) {
    try {
        var div = groups[i].getElementsByClassName("content");
        var pre = div[0].getElementsByClassName("CodeRay highlight");
        var code = pre[0].getElementsByTagName("code");

        codeSnippets.push(groups[i]);
        languageNames.push(code[0].getAttribute('data-lang'));

        // Find next element. If it does not have appropriate DOM elements, an error is thrown
        // (by DOM methods).
        var nextCodeSnippet = $(groups[i]).next();
        var nextDiv = nextCodeSnippet[0].getElementsByClassName("content");
        var nextPre = nextDiv[0].getElementsByClassName("CodeRay highlight");
        var nextCode = nextPre[0].getElementsByTagName("code");
        var atr = nextCode[0].getAttribute('data-lang');

        if (atr == null || atr == undefined) {
            groupEnd();
        } else if (languageNames.includes(atr)) {
            repeatedLanguage = true;
        }

    } catch (e) {
        // Here can we get if for example HTML has some listing blocks that aren't code.
        groupEnd();
        console.log(e.message);
    }
}

// Ends the group and reset arrays for another use. If group meet the requirements
// it will call showMenu and group will be replaced with navbar.
function groupEnd() {
    if (codeSnippets.length > 1 && !repeatedLanguage) {
        showMenu();
    }

    // Reset the data so main loop can use them on another group.
    repeatedLanguage = false;
    codeSnippets = [];
    languageNames = [];
}

// This function shows navigation bar based on arrays languages and code snippets.
// It runs through codeSnippets array and build navbar elements.
function showMenu() {
    var myGroupSnippet = document.createElement("div"); // Division where navbar will come.
    var reservedCodeSnippets = codeSnippets; // Saving code snippets to variable so script can use it when user click on navbar.
    myGroupSnippet.className = "multilistingblock";

    var parent = codeSnippets[0].parentNode;
    parent.insertBefore(myGroupSnippet, codeSnippets[1]);

    var myUl = document.createElement("ul");
    myUl.className = "nav nav-tabs";
    myGroupSnippet.appendChild(myUl);

    var dLi = []; // Array of Li objects.
    var dA = []; // Array of A objects.

    for (var i = 0; i < codeSnippets.length; i++) {
        codeSnippets[i].style.display = 'none';

        var LiO = document.createElement("li");
        LiO.className = "nav-item";

        myUl.appendChild(LiO);
        var AO = document.createElement("a");

        if (i == 0) {
            AO.className = "nav-link active";
        } else {
            AO.className = "nav-link";
        }

        AO.innerText = languageNames[i].toUpperCase();

        LiO.appendChild(AO);
        dLi.push(LiO);
        dA.push(AO);

    }
    var codeDiv = document.createElement("div");

    dA.forEach(function(currentValue, index) {
        currentValue.addEventListener('click', function() {

            var others = myUl.getElementsByClassName("nav-link active");
            for (var j in others) {
                others[j].className = "nav-link";
            }

            currentValue.className = "nav-link active";
            codeDiv.innerHTML = reservedCodeSnippets[index].innerHTML;
        });
    });

    codeDiv.innerHTML = codeSnippets[0].innerHTML;
    myGroupSnippet.appendChild(codeDiv);
}
