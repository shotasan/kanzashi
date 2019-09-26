$(document).on('turbolinks:load', (function() {
    const nested_fields_length = $(".nested-fields").length;

    // ページ更新時にフォーム追加ボタンを非表示にする処理
    if(nested_fields_length === 3) {
        $(".links").hide();
    }

    // 最初のページ表示時にフォーム削除ボタンを非表示にする処理
    if(nested_fields_length === 1) {
        $(".remove-form-link").hide();
    }

    $("#targets")
        .on('cocoon:before-insert', function() {
            if($(".nested-fields").length >= 2) {
                $(".links").hide();
            }
        })
        .on('cocoon:after-remove', function() {
            if($(".nested-fields").length < 3) {
                $(".links").show();
            }
        })

        .on('cocoon:after-remove', function() {
            if($(".nested-fields").length <= 1) {
                $(".remove-form-link").hide();
            }
        });
}));