// ratyによる星の評価機能
$(document).on('ready turbolinks:load',(function() {
    var rating_items = ['rating', 'bitter', 'acidity', 'rich', 'sweet', 'aroma'];

    rating_items.forEach(function (value) {
        $(`#${ value }-form`).raty({
            path: '/assets/',
            scoreName: `review[${value}]`
        })
    });

    $('.review-rating').raty({
        readOnly: true,
        score: function() {
            return $(this).attr('data-score');
        },
        path: '/assets/'
    })
}));

}));