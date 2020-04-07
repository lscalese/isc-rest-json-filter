Class Isc.JSONFiltering.Rest.FilteringDemo Extends %CSP.REST
{

Parameter CONTENTTYPE = {..#CONTENTTYPEJSON};

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/ping" Method="GET" Call="ping" Cors="true"/>
    <Route Url="/demoresponse" Method="GET" Call="demoJsonResponse" Cors="true"/>
</Routes>
}

ClassMethod ping() As %Status
{
    Write { "pong" : ($zdt($h,3,1)) }.%ToJSON()
    Return $$$OK
}

ClassMethod demoJsonResponse() As %DynamicObject
{
    Set json = ..getData()
    Write ##class(Isc.JSONFiltering.Services.FilteringServices).searchCriteriaAndFilter(json).%ToJSON()
    Return $$$OK
}

ClassMethod getData() As %DynamicObject
{
    ; Generated with https://next.json-generator.com/
    Return [{
        "_id": "5e8881a415fd83991d5fbab9",
        "index": 0,
        "guid": "5842b127-1928-48cc-abf2-423c2ce12da0",
        "isActive": true,
        "balance": "$3,831.55",
        "picture": "http://placehold.it/32x32",
        "age": 22,
        "eyeColor": "blue",
        "name": {
        "first": "Edith",
        "last": "Scott"
        },
        "company": "ACCEL",
        "email": "edith.scott@accel.info",
        "phone": "+1 (954) 458-2524",
        "address": "548 Foster Avenue, Williamson, Federated States Of Micronesia, 5185",
        "about": "Minim duis ullamco proident do elit ut reprehenderit reprehenderit culpa. Lorem reprehenderit elit tempor quis est commodo magna do consequat duis minim deserunt. Id consectetur quis ex ea. Esse adipisicing incididunt laborum qui quis aliqua anim duis.",
        "registered": "Friday, July 4, 2014 5:46 PM",
        "latitude": "1.753739",
        "longitude": "-36.313974",
        "tags": [
        "ipsum",
        "ullamco",
        "Lorem",
        "velit",
        "qui"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Perkins Cruz",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Burns Sandoval",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Miranda Barker",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Edith! You have 5 unread messages.",
        "favoriteFruit": "strawberry"
    },
    {
        "_id": "5e8881a411c077f67788defd",
        "index": 1,
        "guid": "9ec86eec-ce78-4e32-b8b0-63d1e18e7a8d",
        "isActive": true,
        "balance": "$2,387.64",
        "picture": "http://placehold.it/32x32",
        "age": 20,
        "eyeColor": "brown",
        "name": {
        "first": "Aurelia",
        "last": "Colon"
        },
        "company": "BILLMED",
        "email": "aurelia.colon@billmed.com",
        "phone": "+1 (861) 426-3482",
        "address": "877 Highlawn Avenue, Harborton, Kentucky, 8103",
        "about": "Irure anim in incididunt fugiat id cupidatat consectetur veniam ea qui esse qui. Cillum exercitation mollit qui labore esse ullamco qui aliquip in dolore velit. Aliqua minim cupidatat anim esse occaecat velit ut veniam commodo ex. Mollit deserunt nostrud adipisicing ipsum sunt consequat ipsum. Consectetur et dolor ea anim deserunt ex est nostrud minim pariatur. Enim Lorem anim labore do amet elit laboris exercitation tempor. Labore sint reprehenderit culpa in enim reprehenderit labore duis excepteur in id.",
        "registered": "Tuesday, March 13, 2018 10:53 PM",
        "latitude": "31.491312",
        "longitude": "149.654901",
        "tags": [
        "occaecat",
        "nostrud",
        "reprehenderit",
        "elit",
        "adipisicing"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Justice Beard",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Merle Moreno",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Caitlin Griffith",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Aurelia! You have 10 unread messages.",
        "favoriteFruit": "strawberry"
    },
    {
        "_id": "5e8881a4d6f2fd49a33f7186",
        "index": 2,
        "guid": "f65ce661-507b-46ff-bcf4-2c2aedf3e699",
        "isActive": true,
        "balance": "$3,406.95",
        "picture": "http://placehold.it/32x32",
        "age": 38,
        "eyeColor": "blue",
        "name": {
        "first": "Day",
        "last": "Patrick"
        },
        "company": "KINDALOO",
        "email": "day.patrick@kindaloo.org",
        "phone": "+1 (810) 563-2346",
        "address": "136 Robert Street, Muir, South Dakota, 5849",
        "about": "Id consequat incididunt dolor voluptate esse sit. Mollit elit velit ea sunt. Proident nisi et irure quis ullamco adipisicing aliqua est enim. Incididunt esse sunt qui anim quis et proident proident. Cupidatat eiusmod Lorem Lorem dolore laborum nisi anim. Est est pariatur nulla reprehenderit nostrud aute laborum non consequat anim duis consequat. Labore esse duis aliqua non qui quis eu occaecat et id cupidatat quis laborum.",
        "registered": "Thursday, October 25, 2018 9:44 PM",
        "latitude": "-15.826144",
        "longitude": "131.722544",
        "tags": [
        "commodo",
        "fugiat",
        "consequat",
        "esse",
        "elit"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Snyder Gilmore",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Knight Cox",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Sheree Weber",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Day! You have 7 unread messages.",
        "favoriteFruit": "banana"
    },
    {
        "_id": "5e8881a4f9a05fca4003b18b",
        "index": 3,
        "guid": "e6828692-3728-404c-8afa-eb3cedcbb239",
        "isActive": false,
        "balance": "$3,681.93",
        "picture": "http://placehold.it/32x32",
        "age": 26,
        "eyeColor": "blue",
        "name": {
        "first": "Erma",
        "last": "Caldwell"
        },
        "company": "ZOINAGE",
        "email": "erma.caldwell@zoinage.co.uk",
        "phone": "+1 (991) 573-3812",
        "address": "655 Balfour Place, Freeburn, Virgin Islands, 2889",
        "about": "Adipisicing eu velit cillum sit consectetur culpa duis ut mollit Lorem quis duis. Do est sit do dolor voluptate exercitation ea. Ad dolor sit laborum nulla sit quis ad pariatur excepteur.",
        "registered": "Thursday, December 13, 2018 3:00 AM",
        "latitude": "65.495199",
        "longitude": "115.698491",
        "tags": [
        "officia",
        "aliqua",
        "exercitation",
        "non",
        "esse"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Nguyen Figueroa",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Ruby Williamson",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Sloan Humphrey",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Erma! You have 7 unread messages.",
        "favoriteFruit": "banana"
    },
    {
        "_id": "5e8881a46bee732498818079",
        "index": 4,
        "guid": "1d1aadeb-f24c-4762-9b94-1565ad94ae1b",
        "isActive": true,
        "balance": "$3,535.59",
        "picture": "http://placehold.it/32x32",
        "age": 23,
        "eyeColor": "brown",
        "name": {
        "first": "Slater",
        "last": "Sanchez"
        },
        "company": "SLOGANAUT",
        "email": "slater.sanchez@sloganaut.tv",
        "phone": "+1 (985) 444-3434",
        "address": "408 Harway Avenue, Fairview, Mississippi, 5871",
        "about": "Quis nostrud consectetur ex duis id non. Qui labore sit duis deserunt dolore. Eu qui aliquip mollit culpa ex minim do cillum est cupidatat.",
        "registered": "Friday, August 16, 2019 10:04 AM",
        "latitude": "-72.10541",
        "longitude": "136.897833",
        "tags": [
        "nisi",
        "consequat",
        "dolor",
        "deserunt",
        "adipisicing"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Karin Pugh",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Dorsey Hampton",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Tanya Romero",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Slater! You have 7 unread messages.",
        "favoriteFruit": "strawberry"
    },
    {
        "_id": "5e8881a4cb7dbd26d16e4545",
        "index": 5,
        "guid": "9fa338cd-4181-4601-bb7d-d1e5530da80b",
        "isActive": true,
        "balance": "$1,876.77",
        "picture": "http://placehold.it/32x32",
        "age": 23,
        "eyeColor": "brown",
        "name": {
        "first": "Little",
        "last": "Lindsay"
        },
        "company": "ENTOGROK",
        "email": "little.lindsay@entogrok.name",
        "phone": "+1 (942) 442-2110",
        "address": "478 Lynch Street, Coyote, Palau, 4233",
        "about": "Ut cupidatat tempor esse ad commodo officia ea velit irure officia cillum nisi nisi. Velit aute minim quis eu nisi deserunt proident. Labore cupidatat veniam consequat dolore tempor amet ea ad dolor ea veniam consectetur commodo aute. Quis minim anim deserunt fugiat. Aliqua aute cillum fugiat elit do Lorem adipisicing sit magna amet. Et duis cillum irure elit.",
        "registered": "Sunday, July 28, 2019 8:06 PM",
        "latitude": "21.001824",
        "longitude": "130.420208",
        "tags": [
        "ex",
        "culpa",
        "duis",
        "pariatur",
        "amet"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Shawn Stanton",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Kayla Estrada",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Joan Hunter",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Little! You have 5 unread messages.",
        "favoriteFruit": "banana"
    },
    {
        "_id": "5e8881a4068c6fc4414411bf",
        "index": 6,
        "guid": "1da64588-1748-4130-8cd8-62952819f9f9",
        "isActive": true,
        "balance": "$2,455.63",
        "picture": "http://placehold.it/32x32",
        "age": 39,
        "eyeColor": "blue",
        "name": {
        "first": "Loraine",
        "last": "Wagner"
        },
        "company": "COASH",
        "email": "loraine.wagner@coash.biz",
        "phone": "+1 (933) 457-2108",
        "address": "704 Hubbard Place, Hampstead, Iowa, 5058",
        "about": "Ullamco magna excepteur magna Lorem officia eiusmod ut ullamco labore. Est adipisicing veniam non commodo ea sint nulla amet culpa. Ad sunt do elit id excepteur. Nisi duis Lorem aliquip exercitation eu reprehenderit pariatur laborum ea culpa elit duis ex. Ullamco ad ullamco et reprehenderit aliquip tempor quis. Aute nostrud proident nulla excepteur nisi cupidatat laboris aliqua occaecat labore ut commodo ut velit.",
        "registered": "Saturday, December 1, 2018 3:34 PM",
        "latitude": "52.632069",
        "longitude": "148.93372",
        "tags": [
        "esse",
        "reprehenderit",
        "ullamco",
        "velit",
        "enim"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Perry Nguyen",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Fisher Calhoun",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Elena Keith",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Loraine! You have 9 unread messages.",
        "favoriteFruit": "apple"
    },
    {
        "_id": "5e8881a411dc1104f643a09a",
        "index": 7,
        "guid": "37d18cf7-5a3e-4dc6-8ffa-3e5d29e86539",
        "isActive": true,
        "balance": "$3,697.33",
        "picture": "http://placehold.it/32x32",
        "age": 40,
        "eyeColor": "green",
        "name": {
        "first": "Marion",
        "last": "Alford"
        },
        "company": "TWIGGERY",
        "email": "marion.alford@twiggery.ca",
        "phone": "+1 (962) 579-2760",
        "address": "404 Albemarle Terrace, Stonybrook, Washington, 5966",
        "about": "Irure id nisi sit occaecat laboris sint. Ea qui anim incididunt ea. Minim dolor pariatur ad nisi sit dolore sit aute nostrud ea laboris ex velit sint. Occaecat non et ex adipisicing.",
        "registered": "Tuesday, August 21, 2018 1:07 AM",
        "latitude": "-62.331608",
        "longitude": "-95.23928",
        "tags": [
        "irure",
        "excepteur",
        "reprehenderit",
        "proident",
        "minim"
        ],
        "range": [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9
        ],
        "friends": [
        {
            "id": 0,
            "name": "Adriana Goodman",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 1,
            "name": "Evangeline Singleton",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        },
        {
            "id": 2,
            "name": "Francine Foster",
            "address":[{"city":"London","street":"no value"},{"city":"Roma","street":"no value"}]
        }
        ],
        "greeting": "Hello, Marion! You have 8 unread messages.",
        "favoriteFruit": "apple"
    }]
}

}
