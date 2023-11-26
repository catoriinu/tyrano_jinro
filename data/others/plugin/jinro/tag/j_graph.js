/**
 * @see https://github.com/ShikemokuMK/tyranoscript/blob/189d5f1bdf9bce0134ceeff5889863706e4dd6b3/tyrano/plugins/kag/kag.tag.js#L2436C1-L2498C3
 */
tyrano.plugin.kag.tag.j_graph = {
    vital: ["storage"],

    pm: {
        storage: null,
        height: null,
        width: null
    },

    //開始
    start: function (pm) {
        var jtext = this.kag.getMessageInnerLayer();

        var current_str = "";

        if (jtext.find("p").find(".current_span").length != 0) {
            current_str = jtext.find("p").find(".current_span").html();
        }

        var storage_url = "";

        if ($.isHTTP(pm.storage)) {
            storage_url = pm.storage;
        } else {
            storage_url = "./data/image/" + pm.storage;
        }

        // 高さと幅を設定
        let height_attr = "";
        if (pm.height) {
            height_attr = " height='" + pm.height + "'";
        }
        let width_attr = "";
        if (pm.width) {
            width_attr = " width='" + pm.width + "'";
        }

        //テキストエリアに画像を追加して、次のメッセージへ晋
        this.kag.appendMessage(jtext, current_str + "<img src='" + storage_url + "'" + height_attr + width_attr + ">");

        this.kag.ftag.nextOrder();
    },
};
tyrano.plugin.kag.ftag.master_tag.j_graph = tyrano.plugin.kag.tag.j_graph
tyrano.plugin.kag.ftag.master_tag.j_graph.kag = tyrano.plugin.kag
