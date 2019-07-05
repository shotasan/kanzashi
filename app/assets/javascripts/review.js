// ratyによる星の評価機能
$(document).on('ready turbolinks:load',(function() {
    var rating_items = ['rating', 'bitter', 'acidity', 'rich', 'sweet', 'aroma'];

    // 新規作成画面での処理
    rating_items.forEach(function(value) {
        $(`#${ value }-form`).raty({
            path: '/assets/',
            scoreName: `review[${value}]`
        })
    });

    // 詳細画面での表示処理
    rating_items.forEach(function(value) {
        $(`.${ value }-rating`).raty({
            readOnly: true,
            score: function() {
                return $(this).attr('data-score');
            },
            path: '/assets/'
        })
    });
}));

// 画像のプレビュー機能
$(document).on('ready turbolinks:load',(function() {
    $(function () {
        $('.image_file').change(function () {
            // 画像の情報を取得
            var file = this.files[0];
            var img_tag_id = $(this).data('imageTagId');

            // 指定の拡張子以外の場合はアラート
            var permit_type = ['image/jpeg', 'image/png', 'image/gif', 'image/jpg'];
            if (file && permit_type.indexOf(file.type) == -1) {
                alert('この形式のファイルはアップロードできません');
                $(this).val('');
                $(img_tag_id).attr('src', '');
                return
            }

            // 読み込んだ画像を取得し、フォームの直後に表示させる
            var reader = new FileReader();
            reader.onload = function () {
                $(img_tag_id).attr('src', reader.result);
                $(img_tag_id + '_prev').attr('src', '');
            };

            // 画像の読み込み
            reader.readAsDataURL(file);

            // テストのためにクラスを追加する処理
            $(img_tag_id).addClass(file.name);

            // 非表示状態のプレビュー欄を表示
            $('#preview-image').show()
        });

    });
}));