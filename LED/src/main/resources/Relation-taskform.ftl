<input type="hidden" name="taskId" value="${task.id}"/>
<input type="hidden" id="pid" name="in_pid" value="${in_pid}"/>
<#if task.taskData.status = 'Ready'>	
   <h4>タスクを始めるには、引受する必要があります</h4> 
</#if>
<#if task.taskData.status = 'Reserved'>	
   <h4>入力する場合はタスクをスタートして下さい。</h4> 
</#if> 
<#if task.taskData.status = 'InProgress'>    
            <div class="row-fluid">
                <div class="span12">
                <div id="process">
                    <div class="tabbable">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#customer" data-toggle="tab">顧客データ選択・入力</a></li>
                            <li><a href="#contract" data-toggle="tab" class="tab-item tab-item-designer">契約者選択</a></li>
                            <li><a href="#bill" data-toggle="tab" class="tab-item tab-item-designer">請求先選択</a></li>
                            <li><a href="#refer" data-toggle="tab" class="tab-item tab-item-designer">紹介元選択</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="customer" class="tab-pane active">
                                <hr>
                                    <div id="shop"></div>
                                <input type="button" class="release btn-large btn-primary" value="リリース"/>
                                <input type="button" class="save btn-large btn-primary" value="保存"/>
                                <input type="button" class="complete btn-large btn-primary" value="完了"/>
                            </div>
                            <div id="contract" class="tab-pane">
                                <hr>
                                <div class="row-fluid">
                                    <div class="span12">
                                        <div>
                                            <table class="dataTable table table-striped table-bordered table-hover">
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="bill" class="tab-pane">
                                <hr>
                                <div class="row-fluid">
                                    <div class="span12">
                                        <div>
                                            <table class="dataTable table table-striped table-bordered table-hover">
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="refer" class="tab-pane">
                                <hr>
                                <div class="row-fluid">
                                    <div class="span12">
                                        <div>
                                            <table class="dataTable table table-striped table-bordered table-hover">
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
 				</div>
<script>
    formView.init = function () {
        var Alpaca = jQuery.alpaca;
        var pid = jQuery('#pid').val();
        var cid = '';
        jQuery.ajax({
            url: Alpaca.user.server + "/server/data/plenty/ＬＥＤレンタル?id=" + pid,
            type: "GET",
            dataType: "json",
            contentType: "application/json; charset=UTF-8"
        }).done(function (data) {
        var pageId = "顧客紐付";
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
                        "dataSource":  Alpaca.user.server + "/server/data/plenty/顧客?id=" +  data.顧客ＩＤ
                    });
                    cid = data.顧客ＩＤ;
                });

        var dataTableURL = Alpaca.user.server + "/server/dataTable/plenty/";
        var collectionName = "顧客";
        jQuery('#contract .dataTable')
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
                    "fnServerData": function ( sSource, aoData, fnCallback ) {
                        for (k = 0; k < aoData.length; k++) {
                            if (aoData[k].name == "sSearch_1")
                                aoData[k].value = true;
                        }
                        $.getJSON( sSource, aoData, function (json) {
                            fnCallback(json)
                        } );
                    },
                    "aoColumns": [
                        {
                            mData: "_id.$oid",
                            sTitle: "ID",
                            "sWidth": "10%"
                        },
                        {
                            mData: "契約者",
                            sTitle: "契約者",
                            bVisible: false
                        },
                        {
                            mData: "名称",
                            sTitle: "名称"
                        },
                        {
                            mData: "住所.郵便番号",
                            sTitle: "郵便番号"
                        },
                        {
                            mData: "住所.都道府県",
                            sTitle: "都道府県"
                        },
                        {
                            mData: "住所.市区町村",
                            sTitle: "市区町村"
                        },
                        {
                            mData: "住所.番地",
                            sTitle: "番地"
                        },
                        {
                            mData: "住所.建物名",
                            sTitle: "建物名"
                        },
                        {
                            mData: "電話番号",
                            sTitle: "電話番号"
                        }
                    ],
                    "fnDrawCallback": function (oSettings) {
                        jQuery('#contract .dataTable tbody tr').click(function () {
                            var nTds = jQuery('td', this);
                            var id = jQuery(nTds[0]).text();
                            jQuery.ajax({
                                url: Alpaca.user.server + "/server/data/plenty/顧客?id=" + id,
                                dataType: "json",
                                contentType: "application/json; charset=UTF-8"
                            }).done(function(responseText){
                                        var json = Alpaca.fieldInstances["顧客"].getValue();
                                        json.契約者ＩＤ=responseText._id.$oid;
                                        Alpaca.fieldInstances["顧客"].setValue(json);
                                    });
                        });
                    }
                });

        jQuery('#bill .dataTable')
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
                    "fnServerData": function ( sSource, aoData, fnCallback ) {
                        for (k = 0; k < aoData.length; k++) {
                            if (aoData[k].name == "sSearch_1")
                                aoData[k].value = true;
                        }
                        $.getJSON( sSource, aoData, function (json) {
                            fnCallback(json)
                        } );
                    },
                    "aoColumns": [
                        {
                            mData: "_id.$oid",
                            sTitle: "ID",
                            "sWidth": "10%"
                        },
                        {
                            mData: "請求先",
                            sTitle: "請求先",
                            bVisible: false
                        },
                        {
                            mData: "名称",
                            sTitle: "名称"
                        },
                        {
                            mData: "住所.郵便番号",
                            sTitle: "郵便番号"
                        },
                        {
                            mData: "住所.都道府県",
                            sTitle: "都道府県"
                        },
                        {
                            mData: "住所.市区町村",
                            sTitle: "市区町村"
                        },
                        {
                            mData: "住所.番地",
                            sTitle: "番地"
                        },
                        {
                            mData: "住所.建物名",
                            sTitle: "建物名"
                        },
                        {
                            mData: "電話番号",
                            sTitle: "電話番号"
                        }
                    ],
                    "fnDrawCallback": function (oSettings) {
                        jQuery('#bill .dataTable tbody tr').click(function () {
                            var nTds = jQuery('td', this);
                            var id = jQuery(nTds[0]).text();
                            jQuery.ajax({
                                url: Alpaca.user.server + "/server/data/plenty/顧客?id=" + id,
                                dataType: "json",
                                contentType: "application/json; charset=UTF-8"
                            }).done(function(responseText){
                                        var json = Alpaca.fieldInstances["顧客"].getValue();
                                        json.請求先ＩＤ=responseText._id.$oid;
                                        Alpaca.fieldInstances["顧客"].setValue(json);
                                    });
                        });
                    }
                });

        jQuery('#refer .dataTable')
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
                    "fnServerData": function ( sSource, aoData, fnCallback ) {
                        for (k = 0; k < aoData.length; k++) {
                            if (aoData[k].name == "sSearch_1")
                                aoData[k].value = true;
                        }
                        $.getJSON( sSource, aoData, function (json) {
                            fnCallback(json)
                        } );
                    },
                    "aoColumns": [
                        {
                            mData: "_id.$oid",
                            sTitle: "ID",
                            "sWidth": "10%"
                        },
                        {
                            mData: "紹介元",
                            sTitle: "紹介元",
                            bVisible: false
                        },
                        {
                            mData: "名称",
                            sTitle: "名称"
                        },
                        {
                            mData: "住所.郵便番号",
                            sTitle: "郵便番号"
                        },
                        {
                            mData: "住所.都道府県",
                            sTitle: "都道府県"
                        },
                        {
                            mData: "住所.市区町村",
                            sTitle: "市区町村"
                        },
                        {
                            mData: "住所.番地",
                            sTitle: "番地"
                        },
                        {
                            mData: "住所.建物名",
                            sTitle: "建物名"
                        },
                        {
                            mData: "電話番号",
                            sTitle: "電話番号"
                        }
                    ],
                    "fnDrawCallback": function (oSettings) {
                        jQuery('#refer .dataTable tbody tr').click(function () {
                            var nTds = jQuery('td', this);
                            var id = jQuery(nTds[0]).text();
                            jQuery.ajax({
                                url: Alpaca.user.server + "/server/data/plenty/顧客?id=" + id,
                                dataType: "json",
                                contentType: "application/json; charset=UTF-8"
                            }).done(function(responseText){
                                        var json = Alpaca.fieldInstances["顧客"].getValue();
                                        json.紹介元ＩＤ=responseText._id.$oid;
                                        Alpaca.fieldInstances["顧客"].setValue(json);
                                   });
                        });
                    }
                });
        });

        jQuery("#process .release").click(function () {
                releaseTask(getFormValues(document.getElementById("form-data")));
        });
        jQuery("#process .save").click(function () {
            Alpaca.fieldInstances["顧客"].validate(true);
            Alpaca.fieldInstances["顧客"].renderValidationState(true);
            if (Alpaca.fieldInstances["顧客"].isValid(true)) {
                var json = Alpaca.fieldInstances["顧客"].getValue();
                json._id = { "$oid" : cid};
                jQuery.ajax({
                    url: Alpaca.user.server + "/server/data/plenty/顧客",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(json)
                }).done(function (responseText) {
                            alert("OID:" + responseText._id.$oid + "で更新できました。");
                        });
            }
        });
        jQuery("#process .complete").click(function () {
            Alpaca.fieldInstances["顧客"].validate(true);
            Alpaca.fieldInstances["顧客"].renderValidationState(true);
            if (Alpaca.fieldInstances["顧客"].isValid(true)) {
                var json = Alpaca.fieldInstances["顧客"].getValue();
                json._id = { "$oid" : cid};
                jQuery.ajax({
                    url: Alpaca.user.server + "/server/data/plenty/顧客",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=UTF-8",
                    data: JSON.stringify(json)
                }).done(function (responseText) {
                            completeTask(getFormValues(document.getElementById("form-data")));
                        });
            }
        });
    };

</script>            
</#if> 