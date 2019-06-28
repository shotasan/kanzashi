var rating_item = ['rating', 'bitter', 'acidity', 'rich', 'sweet', 'aroma'];

$(document).on('ready turbolinks:load',(function() {
    rating_item.forEach(function (value) {
        $(`#${ value }-form`).raty({
            path: '/assets/',
            scoreName: `review[${value}]`,
            score: 1
        })
    });
}));