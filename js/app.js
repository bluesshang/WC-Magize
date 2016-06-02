
var dataViewer = null;

var bizTypes = [
    { id: 0, name: '开庭' },
    { id: 1, name: '判决' },
    { id: 2, name: '更正' },
    { id: 3, name: '催告' },
    { id: 4, name: '失踪' },
    { id: 5, name: '执行' },
    { id: 6, name: '上诉' },
    { id: 7, name: '通知' },
    { id: 8, name: '评估' },
    { id: 9, name: '遗失' },
    { id: 10, name: '死亡' },
    { id: 11, name: '破产' },
    { id: 12, name: '仲裁' },
    { id: 13, name: '裁决' },
    { id: 14, name: '鉴定' },
    { id: 15, name: '作废' },
    { id: 16, name: '注销' },
    { id: 17, name: '应为' },
    { id: 18, name: '拍卖' },
    { id: 19, name: '撤销' },
    { id: 20, name: '申请' },
    { id: 21, name: '清算' },
    { id: 100, name: '其他' },
];

//var employees = [];
//    { id: 0, name: "-" },
//    { id: 1, name: "刘志杰" },
//    { id: 2, name: "辛XX" },
//    { id: 3, name: "孔XX" },
//    { id: 4, name: "杨XX" },
//    { id: 5, name: "吕XX" },
//    { id: 6, name: "艾XX" },
//    { id: 7, name: "马XX" },
//    { id: 8, name: "刘XX" },
//];

var magazineNames = [
    { id: 0, name: "文萃报" },
    { id: 1, name: "法制日报" },
    { id: 2, name: "检察日报" },
];

var userLevels = [
    { id: 0, name: "系统管理员" },
    { id: 1, name: "业务员" },
    { id: 2, name: "数据导入员" },
    { id: 3, name: "普通浏览者" },
];

function evalDataStatistics(rs)
{
    for (i = 0; i < rs.length; i++) {
        rs[i].orders = eval(rs[i].orders);
        rs[i].arrival = eval(rs[i].arrival);
        rs[i].receivable = eval(rs[i].receivable);
    }
}

function evalDataQuery(rs) {
    for (i = 0; i < rs.length; i++) {
        rs[i].publishTime = new Date(rs[i].publishTime);
        //if (rs[i].arrivalTime != "")
        //    rs[i].arrivalTime = new Date(rs[i].arrivalTime);
        //rs[i].id = eval(rs[i].id);
        rs[i].arrival = eval(rs[i].arrival);
        rs[i].receivable = eval(rs[i].receivable);
    }
}
