<%@page import="com.jsh.util.Tools" %>
<%@ page language="java" pageEncoding="utf-8" %>
<%
    String path = request.getContextPath();
    String clientIp = Tools.getLocalIp(request);
%>
<!DOCTYPE html>
<html>
<head>
    <title>客户对账</title>
    <meta charset="utf-8">
    <!-- 指定以IE8的方式来渲染 -->
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <link rel="shortcut icon" href="<%=path%>/images/favicon.ico" type="image/x-icon"/>
    <script type="text/javascript" src="<%=path %>/js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="<%=path %>/js/print/print.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=path %>/js/easyui-1.3.5/themes/default/easyui.css"/>
    <link rel="stylesheet" type="text/css" href="<%=path %>/js/easyui-1.3.5/themes/icon.css"/>
    <link type="text/css" rel="stylesheet" href="<%=path %>/css/common.css"/>
    <script type="text/javascript" src="<%=path %>/js/easyui-1.3.5/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=path %>/js/easyui-1.3.5/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="<%=path %>/js/common/outlook_in.js"></script>
    <script type="text/javascript" src="<%=path %>/js/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="<%=path %>/js/common/common.js"></script>
    <script>
        var uid = ${sessionScope.user.id};
    </script>
</head>
<body>
<!-- 查询 -->
<div id="searchPanel" class="easyui-panel" style="padding:10px;" title="查询窗口" iconCls="icon-search" collapsible="true"
     closable="false">
    <table id="searchTable">
        <tr>
            <td>客户：</td>
            <td>
                <input id="OrganId" name="OrganId" style="width:120px;"/>
            </td>
            <td>&nbsp;</td>
            <td>单据日期：</td>
            <td>
                <input type="text" name="searchBeginTime" id="searchBeginTime"
                       onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="txt Wdate" style="width:140px;"/>
            </td>
            <td>-</td>
            <td>
                <input type="text" name="searchEndTime" id="searchEndTime"
                       onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" class="txt Wdate" style="width:140px;"/>
            </td>
            <td>&nbsp;</td>
            <td>
                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" id="searchBtn">查询</a>
                &nbsp;&nbsp;
                <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-print" id="printBtn">打印</a>
            </td>
            <td>&nbsp;</td>
            <td>
                期初应收：<span class="first-total">0</span>&nbsp;&nbsp;
                期末应收：<span class="last-total">0</span>
            </td>
        </tr>
    </table>
</div>

<!-- 数据显示table -->
<div id="tablePanel" class="easyui-panel" style="padding:1px;top:300px;" title="客户对账列表" iconCls="icon-list"
     collapsible="true" closable="false">
    <table id="tableData" style="top:300px;border-bottom-color:#FFFFFF"></table>
</div>

<script type="text/javascript">
    var path = "<%=path %>";
    var cusUrl = path + "/supplier/findBySelect_cus.action?UBType=UserCustomer&UBKeyId=" + uid; //客户接口
    //初始化界面
    $(function () {
        var thisDate = getNowFormatMonth(); //当前月份
        var thisDateTime = getNowFormatDateTime(); //当前时间
        $("#searchBeginTime").val(thisDate + "-01 00:00:00");
        $("#searchEndTime").val(thisDateTime);
        initSupplier(); //初始化客户信息
        initTableData();
        ininPager();
        search();
        print();
    });


    //初始化客户
    function initSupplier() {
        $('#OrganId').combobox({
            url: cusUrl,
            valueField: 'id',
            textField: 'supplier',
            filter: function (q, row) {
                var opts = $(this).combobox('options');
                return row[opts.textField].indexOf(q) > -1;
            }
        });
    }

    //初始化表格数据
    function initTableData() {
        $('#tableData').datagrid({
            height: heightInfo,
            nowrap: false,
            rownumbers: true,
            //动画效果
            animate: false,
            //选中单行
            singleSelect: true,
            pagination: true,
            //交替出现背景
            striped: true,
            pageSize: 10,
            pageList: [10, 50, 100],
            columns: [[
                {
                    title: '单据编号', field: 'number', width: 140,
                    formatter: function (value, row) {
                        return "<a class='n-link' onclick=\"newTab('" + row.number + "','../materials/bill_detail.jsp?n=" + row.number + "&type=" + row.type + "','')\">"
                            + row.number + "</a>";
                    }
                },
                {title: '类型', field: 'type', width: 100},
                {title: '单位名称', field: 'supplierName', width: 200},
                {title: '单据金额', field: 'discountLastMoney', width: 80},
                {title: '实际支付', field: 'changeAmount', width: 80},
                {title: '本期变化', field: 'allPrice', width: 80},
                {title: '单据日期', field: 'operTime', width: 140}
            ]],
            onLoadError: function () {
                $.messager.alert('页面加载提示', '页面加载异常，请稍后再试！', 'error');
                return;
            }
        });
    }

    //初始化键盘enter事件
    $(document).keydown(function (event) {
        //兼容 IE和firefox 事件
        var e = window.event || event;
        var k = e.keyCode || e.which || e.charCode;
        //兼容 IE,firefox 兼容
        var obj = e.srcElement ? e.srcElement : e.target;
        //绑定键盘事件为 id是指定的输入框才可以触发键盘事件 13键盘事件 ---遗留问题 enter键效验 对话框会关闭问题
        if (k == "13" && (obj.id == "Type" || obj.id == "Name")) {
            $("#savePerson").click();
        }
        //搜索按钮添加快捷键
        if (k == "13" && (obj.id == "searchType")) {
            $("#searchBtn").click();
        }
    });

    //分页信息处理
    function ininPager() {
        try {
            var opts = $("#tableData").datagrid('options');
            var pager = $("#tableData").datagrid('getPager');
            pager.pagination({
                onSelectPage: function (pageNum, pageSize) {
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh',
                        {
                            pageNumber: pageNum,
                            pageSize: pageSize
                        });
                    showDetails(pageNum, pageSize);
                }
            });
        }
        catch (e) {
            $.messager.alert('异常处理提示', "分页信息异常 :  " + e.name + ": " + e.message, 'error');
        }
    }

    //增加
    var url;
    var personID = 0;
    //保存编辑前的名称
    var orgPerson = "";

    //搜索处理
    function search() {
        showDetails(1, initPageSize);
        var opts = $("#tableData").datagrid('options');
        var pager = $("#tableData").datagrid('getPager');
        opts.pageNumber = 1;
        opts.pageSize = initPageSize;
        pager.pagination('refresh',
            {
                pageNumber: 1,
                pageSize: initPageSize
            });
    }

    $("#searchBtn").unbind().bind({
        click: function () {
            search();
        }
    });

    function showDetails(pageNo, pageSize) {
        $.ajax({
            type: "post",
            url: "<%=path %>/depotHead/findStatementAccount.action",
            dataType: "json",
            data: ({
                pageNo: pageNo,
                pageSize: pageSize,
                BeginTime: $("#searchBeginTime").val(),
                EndTime: $("#searchEndTime").val(),
                OrganId: $('#OrganId').combobox('getValue'),
                supType: "客户"
            }),
            success: function (res) {
                if (res) {
                    $("#tableData").datagrid('loadData', res);
                    //如果选择了单位信息，就进行计算期初和期末
                    var supplierId = $('#OrganId').combobox('getValue');
                    if (supplierId) {
                        //先查找期初信息
                        var beginNeedGet = 0;
                        var beginNeedPay = 0;
                        $.ajax({
                            type: "post",
                            url: "<%=path %>/supplier/findById.action",
                            dataType: "json",
                            async: false,
                            data: ({
                                supplierID: supplierId
                            }),
                            success: function (res) {
                                if (res && res.rows && res.rows[0]) {
                                    if (res.rows[0].BeginNeedGet) {
                                        beginNeedGet = res.rows[0].BeginNeedGet;
                                    }
                                    if (res.rows[0].BeginNeedPay) {
                                        beginNeedPay = res.rows[0].BeginNeedPay;
                                    }
                                    //显示期初结存
                                    var searchBeginTime = $("#searchBeginTime").val(); //开始时间
                                    $.ajax({
                                        type: "post",
                                        url: "<%=path %>/depotHead/findTotalPay.action",
                                        dataType: "json",
                                        async: false,
                                        data: ({
                                            supplierId: supplierId,
                                            EndTime: searchBeginTime,
                                            supType: "customer"
                                        }),
                                        success: function (res) {
                                            if (res) {
                                                var moneyA = res.getAllMoney.toFixed(2) - 0;
                                                $.ajax({
                                                    type: "post",
                                                    url: "<%=path %>/accountHead/findTotalPay.action",
                                                    dataType: "json",
                                                    async: false,
                                                    data: ({
                                                        supplierId: supplierId,
                                                        EndTime: searchBeginTime,
                                                        supType: "customer"
                                                    }),
                                                    success: function (res) {
                                                        if (res) {
                                                            var moneyB = res.getAllMoney.toFixed(2) - 0;
                                                            var money = moneyA + moneyB;
                                                            var moneyBeginNeedGet = beginNeedGet - 0; //期初应收
                                                            var moneyBeginNeedPay = beginNeedPay - 0; //期初应付
                                                            money = (money + moneyBeginNeedGet - moneyBeginNeedPay).toFixed(2);
                                                            $(".first-total").text(money); //期初结存
                                                        }
                                                    },
                                                    error: function () {
                                                        $.messager.alert('提示', '网络异常请稍后再试！', 'error');
                                                        return;
                                                    }
                                                });
                                            }
                                        },
                                        error: function () {
                                            $.messager.alert('提示', '网络异常请稍后再试！', 'error');
                                            return;
                                        }
                                    })

                                    //显示期末合计
                                    var searchEndTime = $("#searchEndTime").val(); //结束时间
                                    $.ajax({
                                        type: "post",
                                        url: "<%=path %>/depotHead/findTotalPay.action",
                                        dataType: "json",
                                        async: false,
                                        data: ({
                                            supplierId: supplierId,
                                            EndTime: searchEndTime,
                                            supType: "customer"
                                        }),
                                        success: function (res) {
                                            if (res) {
                                                var moneyA = res.getAllMoney.toFixed(2) - 0;
                                                $.ajax({
                                                    type: "post",
                                                    url: "<%=path %>/accountHead/findTotalPay.action",
                                                    dataType: "json",
                                                    async: false,
                                                    data: ({
                                                        supplierId: supplierId,
                                                        EndTime: searchEndTime,
                                                        supType: "customer"
                                                    }),
                                                    success: function (res) {
                                                        if (res) {
                                                            var moneyB = res.getAllMoney.toFixed(2) - 0;
                                                            var money = moneyA + moneyB;
                                                            var moneyBeginNeedGet = beginNeedGet - 0; //期初应收
                                                            var moneyBeginNeedPay = beginNeedPay - 0; //期初应付
                                                            money = (money + moneyBeginNeedGet - moneyBeginNeedPay).toFixed(2);
                                                            $(".last-total").text(money); //期末合计
                                                        }
                                                    },
                                                    error: function () {
                                                        $.messager.alert('提示', '网络异常请稍后再试！', 'error');
                                                        return;
                                                    }
                                                });
                                            }
                                        },
                                        error: function () {
                                            $.messager.alert('提示', '网络异常请稍后再试！', 'error');
                                            return;
                                        }
                                    })
                                }
                            },
                            error: function () {
                                $.messager.alert('提示', '网络异常请稍后再试！', 'error');
                                return;
                            }
                        });
                    }
                }
            },
            //此处添加错误处理
            error: function () {
                $.messager.alert('查询提示', '查询数据后台异常，请稍后再试！', 'error');
                return;
            }
        });
    }

    //报表打印
    function print() {
        $("#printBtn").off("click").on("click", function () {
            var path = "<%=path %>";
            CreateFormPage('打印报表', $('#tableData'), path);
        });
    }
</script>
</body>
</html>