//
//  ConfigureApi.swift
//  WYP
//
//  Created by 你个LB on 2017/3/6.
//  Copyright © 2017年 NGeLB. All rights reserved.
//

import UIKit

public var access_token: String {
    return "4170fa02947baeed645293310f478bb4"
}

// 服务器地址
public func kApi_baseUrl(path: String) -> String {
//    return "http://ald.unetu.net/\(path)"
    return "http://ald.1001alading.com/\(path)"
//    return "http://ticket.fenxianghulian.com/\(path)"
}


// MARK: - 登录注册绑定
// 单点登录
public var kApi_singleLogin: String {
    return kApi_baseUrl(path: "api/single")
}
// 用户登录
public var kApi_login: String {
    return kApi_baseUrl(path: "api/authorization")
}

// 第三方用户登录
public var kApi_third_party_login: String {
    return kApi_baseUrl(path: "api/third_party_login")
}

// 发送短信验证码
public var kApi_sendVerificationCode: String {
    return kApi_baseUrl(path: "api/reg_verify")
}

// 验证短信验证码
public var kApi_verifyCode: String {
    return kApi_baseUrl(path: "api/yzverify")
}

// 用户注册
public var kApi_register: String {
    return kApi_baseUrl(path: "api/account")
}

// 忘记密码
public var kApi_reset_password: String {
    return kApi_baseUrl(path: "api/reset_password")
}

// 修改密码
public var kApi_modify_password: String {
    return kApi_baseUrl(path: "api/edit_password")
}

// 编辑用户资料
public var kApi_edit_user_info: String {
    return kApi_baseUrl(path: "api/personalSet")
}

// 获取用户信息
public var kApi_getUserInfo: String {
    return kApi_baseUrl(path: "api/userInfo")
}

// 是否加群
public var kApi_getIsJoinGroup: String {
    return kApi_baseUrl(path: "api/qunid")
}

// 获取用户资料
public var kApi_get_user_info: String {
    return kApi_baseUrl(path: "api/PersonalInfo")
}

// 获取收货地址
public var kApi_get_goods_address: String {
    return kApi_baseUrl(path: "api/in_address")
}

// 设置 - 用户绑定状态
public var kApi_bindingStatus: String {
    return kApi_baseUrl(path: "api/binding_status")
}

// 登录注册 - 绑定手机号
public var kApi_bindingMobile: String {
    return kApi_baseUrl(path: "api/binding_mobile")
}

// 设置 - 第三方绑定
public var kApi_userBinding: String {
    return kApi_baseUrl(path: "api/user_binding")
}

// 设置 - 解除绑定
public var kApi_unBinding: String {
    return kApi_baseUrl(path: "api/unbundling")
}


// MARK: - 首页相关接口
// 首页 - 群组更多列表
public var kApi_groupList: String {
    return kApi_baseUrl(path: "api/getGroupMany")
}

// 首页 - 热门资讯更多按钮
public var kApi_homeHotNews: String {
    return kApi_baseUrl(path: "api/hotMore")
}

// 首页列表
public var kApi_homeList: String {
    return kApi_baseUrl(path: "api/home_list")
}

// 首页 - 更多热门话题
public var kApi_homeHotTopic: String {
    return kApi_baseUrl(path: "api/ManyGambit")
}

// 首页 - 更多热门搜索
public var kApi_hotSearch: String {
    return kApi_baseUrl(path: "api/hot_search")
}

// 首页兑换
public var kApi_home_exchange: String {
    return kApi_baseUrl(path: "api/exchange")
}

// 首页 - 热门发现更多按钮
public var kApi_homeHotRoom: String {
    return kApi_baseUrl(path: "api/ManyGroup")
}

// 首页 - 搜索数据
public var kApi_homeSearch: String {
    return kApi_baseUrl(path: "api/GlobalSearch")
}

// 首页 - 搜索票务更多
public var kApi_homeSearchTicket: String {
    return kApi_baseUrl(path: "api/ticketSearchMore")
}

// 首页 - 搜索展厅更多
public var kApi_homeSearchRoom: String {
    return kApi_baseUrl(path: "api/groupSearchMore")
}

// 首页 - 搜索资讯更多
public var kApi_homeSearchNews: String {
    return kApi_baseUrl(path: "api/newsSearchMore")
}

// 首页 - 搜索话题更多
public var kApi_homeSearchGambit: String {
    return kApi_baseUrl(path: "api/gambitSearchMore")
}

// 首页 - 搜索社区更多
public var kApi_homeSearchCommunity: String {
    return kApi_baseUrl(path: "api/dynamic_search_more")
}

// 城市搜索
public var kApi_citySearch: String {
    return kApi_baseUrl(path: "api/cheng")
}

// MARK: - 资讯相关接口
// 获取资讯图集详情
public var kApi_getPhotoDetail: String {
    return kApi_baseUrl(path: "api/Message/tuji")
}

// 资讯列表接口
public var kApi_news: String {
    return kApi_baseUrl(path: "api/news")
}

// 资讯 - 搜索页面
public var kApi_newsSearch: String {
    return kApi_baseUrl(path: "api/search")
}

// 资讯 - 点击视频接口
public var kApi_newsVideoDetail: String {
    return kApi_baseUrl(path: "api/news_video")
}

// 资讯详情 - 评论列表
public var kApi_newsCommentList: String {
    return kApi_baseUrl(path: "api/commentList")
}

// 资讯 - 关注资讯
public var kApi_collectionNews: String {
    return kApi_baseUrl(path: "api/followNews")
}

// 资讯 - 图集浏览接口
public var kApi_pictureSee: String {
    return kApi_baseUrl(path: "api/browse_number")
}

// 资讯详情 - 评论详情接口
public var kApi_newsCommentDetail: String {
    return kApi_baseUrl(path: "api/new_reply_detail")
}

// 资讯 - 话题点赞和评论点赞
public var kApi_topicStar: String {
    return kApi_baseUrl(path: "api/news_fabulous")
}

// 资讯 - 话题评论
public var kApi_topicsComment: String {
    return kApi_baseUrl(path: "api/ReGambit")
}

// MARK: - 展厅相关接口
// 展厅列表接口
public var kApi_showRoom: String {
    return kApi_baseUrl(path: "api/group_all")
}

// 展厅详情接口
public var kApi_showRoomDetail: String {
    return kApi_baseUrl(path: "api/group_detail")
}

// 展厅详情 - 展厅收藏按钮
public var kApi_collection: String {
    return kApi_baseUrl(path: "api/getGroupxiangkan")
}

// 展厅详情 - 展厅评论详情
public var kApi_showRoomCommentDetail: String {
    return kApi_baseUrl(path: "api/GroupPlDetail")
}

// 展厅详情 - 演职人员列表
public var kApi_actorMember: String {
    return kApi_baseUrl(path: "api/getGroupMemberone")
}

// 展厅详情 - 添加和取消关注
public var kApi_addOrCancelAttention: String {
    return kApi_baseUrl(path: "api/follow")
}

// 展厅详情 - 最新动态更多按钮
public var kApi_roomDetailNews: String {
    return kApi_baseUrl(path: "api/getGroupNew")
}

// 展厅详情 - 点赞
public var kApi_thumbUp: String {
    return kApi_baseUrl(path: "api/getPostdianzan")
}

// 展厅详情 - 发布展厅评论
public var kApi_issueComment: String {
    return kApi_baseUrl(path: "api/GroupPublish")
}

// 展厅详情 - 企业认证
public var kApi_companyCertification: String {
    return kApi_baseUrl(path: "api/authentication")
}

// 展厅详情 - 视频接口
public var kApi_roomDetailVideo: String {
    return kApi_baseUrl(path: "api/PlayVideo")
}

// 展厅详情 - 图集接口
public var kApi_roomDetailPhoto: String {
    return kApi_baseUrl(path: "api/PlayPhoto")
}

// 展厅 - 搜索结果页
public var kApi_roomSearch: String {
    return kApi_baseUrl(path: "api/GroupSearch")
}

// 展厅详情 - 项目认证
public var kApi_projectCertification: String {
    return kApi_baseUrl(path: "api/get_certified")
}

// 展厅详情 - 关注票务
public var kApi_addAttentionTicket: String {
    return kApi_baseUrl(path: "api/ticketFollow")
}

// 展厅详情 - 资讯评论列表
public var kApi_roomNewsCommentList: String {
    return kApi_baseUrl(path: "api/group_new_list")
}

// 展厅详情 - 资讯评论接口
public var kApi_roomNewsComment: String {
    return kApi_baseUrl(path: "api/group_news_comment")
}

// 展厅详情 - 资讯评论点赞
public var kApi_roomNewsThumbUp: String {
    return kApi_baseUrl(path: "api/group_news_dzan")
}

// 展厅详情 - 资讯二级评论列表
public var kApi_roomNewsSecCommentList: String {
    return kApi_baseUrl(path: "api/group_new_detail")
}

// 展厅最新动态 - 关注
public var kApi_roomNewsAttention: String {
    return kApi_baseUrl(path: "api/group_news_follow")
}

// MARK: - 票务相关
// 票务列表
public var kApi_ticketList: String {
    return kApi_baseUrl(path: "api/ticketIndex")
}

// 票务详情
public var kApi_ticketDetail: String {
    return kApi_baseUrl(path: "api/Groupticket")
}

// 票务 - 二级分类搜索
public var kApi_ticketSecSearch: String {
    return kApi_baseUrl(path: "api/ticketSearch")
}

// 是否参与每日抽奖
public var kApi_everyLottery: String {
    return kApi_baseUrl(path: "api/zhuanpan")
}

// MARK: - 我的
// 我的钱包列表
public var kApi_my_coupon: String {
    return kApi_baseUrl(path: "api/MyWallet")
}
// 我的 - 关注的人
public var kApi_attentionPeoples: String {
    return kApi_baseUrl(path: "api/myFollowPeople")
}

// 我的 - 取消关注的人
public var kApi_peopleCancelAttention: String {
    return kApi_baseUrl(path: "api/delFollowPeople")
}

// 我的 - 关注的票务
public var kApi_attentionTickets: String {
    return kApi_baseUrl(path: "api/myFollowTicket")
}
// 我的 - 取消关注的票务
public var kApi_ticketCancelAttention: String {
    return kApi_baseUrl(path: "api/delFollowTicket")
}

// 我的 - 添加好友搜索列表
public var kApi_addSearchFriends: String {
    return kApi_baseUrl(path: "api/addFriend")
}

// 我的话题列表
public var kApi_my_topicList: String {
    return kApi_baseUrl(path: "api/Gambit_list")
}

//我的话题--新
public var kApi_my_topicListnew: String {
    return kApi_baseUrl(path: "api/gambit_list_info")
}

//我的话题--新
public var kApi_myAnswer_topicListnew: String {
    return kApi_baseUrl(path: "api/re_gambit_list")
}

// 发布话题
public var kApi_issue_Topic: String {
    return kApi_baseUrl(path: "api/sendGambit")
}

// 话题详情
public var kApi_topicDetails: String {
    return kApi_baseUrl(path: "api/GambitDetail")
}

// 删除我的话题
public var kApi_del_my_topic: String {
    return kApi_baseUrl(path: "api/Gambit_del")
}

// 反馈建议
public var kApi_feedback_idea: String {
    return kApi_baseUrl(path: "api/send_idea")
}

// 我的通知
public var kApi_my_notification: String {
    return kApi_baseUrl(path: "api/myMessage")
}

// 删除我的消息列表
public var kApi_deleteNotification: String {
    return kApi_baseUrl(path: "api/deleteMessage")
}

// 我的 - 关注的资讯
public var kApi_attentionNews: String {
    return kApi_baseUrl(path: "api/myFollowNews")
}

// 我的 - 关注的话题
public var kApi_attentionTopic: String {
    return kApi_baseUrl(path: "api/my_follow_topic")
}

// 我的 - 取消关注资讯
public var kApi_newsCancelAttention: String {
    return kApi_baseUrl(path: "api/cancelFollowNews")
}

// 我的 - 群组
public var kApi_myGroupsList: String {
    return kApi_baseUrl(path: "api/qunList")
}

// 我的 - 管理群组
public var kApi_myGroupsChangeList: String {
    return kApi_baseUrl(path: "api/qunzu_manage_list")
}


// 我的 - 关注的展厅
public var kApi_attentionRooms: String {
    return kApi_baseUrl(path: "api/myFollowGroup")
}

// 我的 - 取消关注的展厅
public var kApi_roomCancelAttention: String {
    return kApi_baseUrl(path: "api/delFollowGroup")
}

// 删除动态
public var kApi_deleteCommunity: String {
    return kApi_baseUrl(path: "api/del_community")
}

// 我的 - 邀请好友列表
public var kApi_inviteFriends: String {
    return kApi_baseUrl(path: "api/invite_friends")
}

// 我的 - 反馈记录 
public var kApi_feedBackRecord: String {
    return kApi_baseUrl(path: "api/idea_list")
}

// 我的 - 我的订单
public var kApi_myOrders: String {
    return kApi_baseUrl(path: "api/myOrder")
}
// 我的 - 个人资料
public var kApi_my_home: String {
    return kApi_baseUrl(path: "api/my_home")
}
// 我的 - 订单详情
public var kApi_orderDeatil: String {
    return kApi_baseUrl(path: "api/orderxiangxi")
}

// 我的 - 确认收货
public var kApi_confirmReceipt: String {
    return kApi_baseUrl(path: "api/ordershou")
}

// 我的 - 从钱包等跳转到的收货地址
public var kApi_goodsInfo: String {
    return kApi_baseUrl(path: "api/receiving_address")
}

// 我的 - 反馈详情
public var kApi_recordDetail: String {
    return kApi_baseUrl(path: "api/ideaDetail")
}

// 我的 - 好友验证申请
public var kApi_verifyApplication: String {
    return kApi_baseUrl(path: "api/sendFriendPush")
}

// 我的 - 好友列表
public var kApi_friendsList: String {
    return kApi_baseUrl(path: "api/FriendList")
}

// 我的 - 群组信息 
public var kApi_groupInfo: String {
    return kApi_baseUrl(path: "api/qunzuDetail")
}

// 获取管理群界面接口
public var kApi_getManagerGroupInfo: String {
    return kApi_baseUrl(path: "api/manageGroup")
}

// 设置群管理员
public var kApi_setGroupManager: String {
    return kApi_baseUrl(path: "api/set_group_manager")
}

// 更改入群方式
public var kApi_changeJoinGroupWay: String {
    return kApi_baseUrl(path: "api/switchGroupCheck")
}

// 获取群组信息
public var kApi_getGroupInfo: String {
    return kApi_baseUrl(path: "api/groupInfo")
}

public var kApi_deleteGroupMember: String {
    return kApi_baseUrl(path: "api/del_qun_member")
}


public var kApi_addGroupMember: String {
    return kApi_baseUrl(path: "api/friend_join_group")
}

public var kApi_invitationJoinGroup: String {
    return kApi_baseUrl(path: "api/friend_join_group")
}

// 群公告列表
public var kApi_groupNoteList: String {
    return kApi_baseUrl(path: "api/get_group_board_list")
}

// 发布群公告
public var kApi_publishGroupNote: String {
    return kApi_baseUrl(path: "api/add_group_board")
}

// 群组 - 申请入群
public var kApi_enterGroup: String {
    return kApi_baseUrl(path: "api/jionqunzu")
}

// 我的群组 - 搜索
public var kApi_groupSearch: String {
    return kApi_baseUrl(path: "api/qunzusearch")
}

// 消息推送
public var kApi_notificationPush: String {
    return kApi_baseUrl(path: "api/tuisong")
}

// 我的 - 保存我的收货地址
public var kApi_saveMyAddress: String {
    return kApi_baseUrl(path: "api/save_receiving_address")
}

// 系统设置 - 通用 - 获取当前权限信息
public var kApi_currentPrivacyInfo: String {
    return kApi_baseUrl(path: "api/viewAuth")
}

// 系统设置 - 通用 - 不允许看我的朋友圈
public var kApi_unallowLookMyCommunity: String {
    return kApi_baseUrl(path: "api/no_see_community")
}

// 系统设置 - 通用 - 不允许添加我为好友
public var kApi_unallowAddMe: String {
    return kApi_baseUrl(path: "api/setFriendAuth")
}

// 退群
public var kApi_quiteGroup: String {
    return kApi_baseUrl(path: "api/quitequnzu")
}

// 推荐好友
public var kApi_recommendFriends: String {
    return kApi_baseUrl(path: "api/pushqunzu")
}

// 群组聊天 - 获取用户信息进社区
public var kApi_gotoUserCommunity: String {
    return kApi_baseUrl(path: "api/usercommunity")
}

// MARK: - 广告
// 首页广告轮播图
public var kApi_homeAdv: String {
    return kApi_baseUrl(path: "api/advindex")
}

// 资讯广告轮播图
public var kApi_newsAdv: String {
    return kApi_baseUrl(path: "api/advNews")
}

// 发现广告轮播图
public var kApi_showRoomAdv: String {
    return kApi_baseUrl(path: "api/advFind")
}

// 抽奖广告轮播图
public var kApi_lotteryAdv: String {
    return kApi_baseUrl(path: "api/advTicket")
}

// 问答广告轮播图
public var kApi_questionAdv: String {
    return kApi_baseUrl(path: "api/advAsk")
}

// 投票广告轮播图
public var kApi_voteAdv: String {
    return kApi_baseUrl(path: "api/advVote")
}

// 获取开屏广告
public var kApi_startAdv: String {
    return kApi_baseUrl(path: "api/advPart")
}

// 点击广告
public var kApi_clickAdv: String {
    return kApi_baseUrl(path: "api/advclick")
}

// 分享广告位
public var kApi_shareAdv: String {
    return kApi_baseUrl(path: "api/advshare")
}
// MARK: - 支付
// 微信支付
public var kApi_weChatPay: String {
    return kApi_baseUrl(path: "api/weixin")
}



//发布话题
public var kApi_publicTopic: String {
    return kApi_baseUrl(path: "api/pubGambit")
}

//发布社区
public var kApi_publicCommunity: String {
    return kApi_baseUrl(path: "api/community_release")
}



//个人社区
public var kApi_getPersonCommunity: String {
    return kApi_baseUrl(path: "api/follow_fans_num")
}

//个人社区
public var kApi_getTopicCommtentDetail: String {
    return kApi_baseUrl(path: "api/news_reply_content")
}

//删除话题评论
public var kApi_delCommtentCommentDetail: String {
    return kApi_baseUrl(path: "api/del_re_gambit")
}



//展厅菜单数据
public var kApi_getExhibitionHallMeunData: String {
    return kApi_baseUrl(path: "api/get_category")
}

//媒体库
public var kApi_getMediaList: String {
    return kApi_baseUrl(path: "api/media_list")
}
