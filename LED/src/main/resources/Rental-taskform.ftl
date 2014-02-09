<input type="hidden" name="processId" value="${process.id}"/>
<input type="hidden" id="pid" name="pid" value=""/>
            <div class="row-fluid">
                <div class="span12">
                    <div class="tabbable">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#customer" data-toggle="tab">顧客データ選択・入力</a></li>
                            <li><a href="#process" data-toggle="tab" class="tab-item tab-item-designer">リードデータ入力</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="customer" class="tab-pane active">
                                <label class="radio inline"><input type="radio" value="新規" data-bind="checked: dataType"/>新規</label>
                                <label class="radio inline"><input type="radio" value="既存" data-bind="checked: dataType"/>既存</label>
                                <hr>
                                <div id="choose" class="container-fluid" data-bind="visible: dataType() == '既存'">
                                    <div class="row-fluid">
                                        <div class="span12">
                                            <div>
                                                <table class="dataTable table table-striped table-bordered table-hover">
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="create" data-bind="visible: dataType() == '新規'">
                                    <div id="shop"></div>
                                    <input type="button" class="save btn-large btn-success" value="保存"/>
                                </div>
                            </div>
                            <div id="process" class="tab-pane">
                                <div id="rental"></div>
                                <input type="button" class="save btn-large btn-primary" value="開始"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
<script>
    formView.init = function(){
        var Alpaca = jQuery.alpaca;
        var customerModel = {
            dataType: ko.observable("新規")
        }
        ko.applyBindings(customerModel, document.getElementById("customer"));

        var pageId = "顧客編集";
        $.ajax({
            url: Alpaca.user.server + "/server/design/page/plenty?id=" + pageId,
            type: "GET",
            dataType: "json",
            contentType: "application/json; charset=UTF-8"
        }).done(function (responseText) {
                    jQuery("#shop").alpaca({
                        "schemaSource": Alpaca.user.server + "/server/design/schema/plenty?id=" + responseText.schema,
                        "optionsSource": Alpaca.user.server + "/server/design/options/plenty?id=" + responseText.options + "&sid=" + responseText.schema,
                        "viewSource": Alpaca.user.server + "/server/design/view/plenty/?id=" + responseText.view + "&sid=" + responseText.schema,
                        "data": {}
                    });
                });

        var dataTableURL = Alpaca.user.server + "/server/dataTable/plenty/";
        var collectionName = "顧客";
        jQuery('#customer .dataTable')
                .dataTable(
                {
                    "aLengthMenu": [
                        [ 10, 25, 50, -1 ],
                        [ 10, 25, 50, "全部" ]
                    ],
                    "bAutoWidth": true,
                    "iDisplayLength": 10,
                    "sDom": "<'row-fluid'<'span6'l><'span6'f>r><'row-fluid'<'span12'p>>t<'row-fluid'<'span6'i><'span6'p>>",
                    "sPaginationType": "bootstrap",
                    "oLanguage": {
                        "oAria": {
                            "sSortAscending": ": 昇順にソート",
                            "sSortDescending": ": 降順にソート"
                        },
                        "oPaginate": {
                            "sFirst": "最初",
                            "sLast": "最後",
                            "sNext": "次",
                            "sPrevious": "前"
                        },
                        "sEmptyTable": "表示可能なデータがありません。",
                        "sInfo": "全 _TOTAL_ 件中の _START_ から _END_ を表示中",
                        "sInfoEmpty": "表示可能なデータがありません。",
                        "sInfoFiltered": "(全 _MAX_ 件からフィルター中)",
                        "sInfoPostFix": "",
                        "sInfoThousands": ",",
                        "sLengthMenu": "ページ毎に _MENU_ レコード",
                        "sLoadingRecords": "ロード中...",
                        "sProcessing": "処理中...",
                        "sSearch": "検索:",
                        "sUrl": "",
                        "sZeroRecords": "一致するレコードがありません。"
                    },
                    "bProcessing": true,
                    "bServerSide": true,
                    "sAjaxSource": dataTableURL + collectionName,
                    "aoColumns": [
                        {
                            mData: "_id.$oid",
                            sTitle: "ID",
                            "sWidth": "10%"
                        },
                        {
                            mData: "名称",
                            sTitle: "店舗名"
                        },
                        {
                            mData: "電話番号",
                            sTitle: "電話番号"
                        }
                    ],
                    "fnDrawCallback": function (oSettings) {
                        jQuery('#customer .dataTable tbody tr').click(function () {
                            var nTds = jQuery('td', this);
                            var id = jQuery(nTds[0]).text();
                            jQuery.ajax({
                                url: Alpaca.user.server + "/server/data/plenty/顧客?id=" + id,
                                dataType: "json",
                                contentType: "application/json; charset=UTF-8"
                            }).done(function(responseText){
                                        var json = Alpaca.fieldInstances["ＬＥＤレンタル"].getValue();
                                        json.顧客ＩＤ=responseText._id.$oid;
                                        json.店舗名=responseText.名称;
                                        json.住所=responseText.住所;
                                        json.電話番号=responseText.電話番号;
                                        Alpaca.fieldInstances["ＬＥＤレンタル"].setValue(json);
                                    });
                        });
                    }
                });


        jQuery("#customer .save").click(function () {
            Alpaca.fieldInstances["顧客"].validate(true);
            Alpaca.fieldInstances["顧客"].renderValidationState(true);
            if (Alpaca.fieldInstances["顧客"].isValid(true)) {
                var json = Alpaca.fieldInstances["顧客"].getValue();
                jQuery.ajax({
                    url: Alpaca.user.server + "/server/data/plenty/顧客",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(json)
                }).done(function (responseText) {
                            alert("OID:" + responseText._id.$oid + "で登録できました。");
                            jQuery.ajax({
                                url: Alpaca.user.server + "/server/data/plenty/顧客?id=" + responseText._id.$oid,
                                dataType: "json",
                                contentType: "application/json; charset=UTF-8"
                            }).done(function(responseText){
                                        var json = Alpaca.fieldInstances["ＬＥＤレンタル"].getValue();
                                        json.顧客ＩＤ=responseText._id.$oid;
                                        json.店舗名=responseText.名称;
                                        json.住所=responseText.住所;
                                        json.電話番号=responseText.電話番号;
                                        Alpaca.fieldInstances["ＬＥＤレンタル"].setValue(json);
                                    });
                        });
            }
        });

        pageId = "ＬＥＤ初回面談";
        $.ajax({
            url: Alpaca.user.server + "/server/design/page/plenty?id=" + pageId,
            type: "GET",
            dataType: "json",
            contentType: "application/json; charset=UTF-8"
        }).done(function (responseText) {
                    jQuery("#rental").alpaca({
                        "schemaSource": Alpaca.user.server + "/server/design/schema/plenty?id=" + responseText.schema,
                        "optionsSource": Alpaca.user.server + "/server/design/options/plenty?id=" + responseText.options + "&sid=" + responseText.schema,
                        "viewSource": Alpaca.user.server + "/server/design/view/plenty/?id=" + responseText.view + "&sid=" + responseText.schema,
                        "data": {}
                    });
                });

        jQuery("#process .save").click(function () {
            Alpaca.fieldInstances["ＬＥＤレンタル"].validate(true);
            Alpaca.fieldInstances["ＬＥＤレンタル"].renderValidationState(true);
            if (jQuery("#cid").val() == "") {
                alert("顧客入力または選択して下さい。");
            } else {
                if (Alpaca.fieldInstances["ＬＥＤレンタル"].isValid(true)) {
                    var json = Alpaca.fieldInstances["ＬＥＤレンタル"].getValue();
                    jQuery.ajax({
                        url: Alpaca.user.server + "/server/data/plenty/ＬＥＤレンタル",
                        type: "POST",
                        dataType: "json",
                        contentType: "application/json; charset=UTF-8",
                        data: JSON.stringify(json)
                    }).done(function (responseText) {
                                jQuery("#pid").val(responseText._id.$oid);
                                startProcess(getFormValues(document.getElementById("form-data")));
                            });
                }
            }
        });
    };
</script>