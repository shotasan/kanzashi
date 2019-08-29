$(document).on('turbolinks:load',(function() {
    let rating_items = ['rating', 'bitter', 'acidity', 'rich', 'sweet', 'aroma'];

    rating_items.forEach(function(value) {
        $(`#${ value }-search`)
            .empty()
            .raty({
            path: '/assets/',
            score: 1,
            scoreName: `q[${value}_gteq]`
        });
    });

    // 検索フォーム内のチェックボックス
    $(".checkbox").on("click", function(){
        $('.checkbox').prop('checked', false);
        $(this).prop('checked', true);
    });
}));