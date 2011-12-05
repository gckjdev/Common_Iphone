//
//  DownloadResource.h
//  Download
//
//  Created by  on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageUtil.h"

#define TOP_ICON        @"tu_03-02"
#define RESOURCE_ICON   @"png_08"
#define BROWSE_ICON     @"png_10"
#define DOWNLOAD_ICON   @"png_12"
#define ABOUT_ICON      @"png_14"

#define TOP_PRESS_ICON        @"png_33"
#define RESOURCE_PRESS_ICON   @"png_34"
#define BROWSE_PRESS_ICON     @"png_35"
#define DOWNLOAD_PRESS_ICON   @"png_36"
#define ABOUT_PRESS_ICON      @"png_37"

#define BACKGROUND              @""
#define TABBAR_BACKGROUND       @"tu_16.png"

#define RETURN_ICON_PRESS               @"png_150"
#define FORWARD_ICON_PRESS              @"tu_88-80"
#define BACKWARD_ICON_PRESS             @"png_152"
#define REFRESH_ICON_PRESS              @"png_93-82"
#define STOP_ICON_PRESS                 @"png_156"
#define FAVOURITE_ICON_PRESS            @"tu_95"

#define RETURN_ICON                     @"png_175"
#define FORWARD_ICON                    @"png_178"
#define BACKWARD_ICON                   @"png_176"
#define REFRESH_ICON                    @"png_179"
#define STOP_ICON                       @"tu_90"
#define FAVOURITE_ICON                  @"tu_94-92"

#define RETURN_IMAGE                ([UIImage imageNamed:RETURN_ICON])
#define BACKWARD_IMAGE              ([UIImage imageNamed:BACKWARD_ICON])
#define FORWARD_IMAGE               ([UIImage imageNamed:FORWARD_ICON])
#define REFRESH_IMAGE               ([UIImage imageNamed:REFRESH_ICON])
#define STOP_IMAGE                  ([UIImage imageNamed:STOP_ICON])
#define FAVOURITE_IMAGE             ([UIImage imageNamed:FAVOURITE_ICON])

#define ACTION_BUTTON                   @"tu_88"
#define ACTION_BUTTON_PRESS             @"tu_89"

#define ACTION_BUTTON_IMAGE           ([UIImage strectchableImageName:ACTION_BUTTON])
#define ACTION_BUTTON_PRESS_IMAGE     ([UIImage strectchableImageName:ACTION_BUTTON_PRESS])

#define AUDIOTYPE_LABEL                  @"tu_34.png"
#define IMAGETYPE_LABEL                  @"tu_36.png"
#define ALLTYPE_LABEL                  @"tu_38.png"

#define AUDIOTYPE_LABEL_BG_IMAGE [UIImage strectchableImageName:AUDIOTYPE_LABEL]
#define IMAGETYPE_LABEL_BG_IMAGE [UIImage strectchableImageName:IMAGETYPE_LABEL]
#define ALLTYPE_LABEL_BG_IMAGE [UIImage strectchableImageName:ALLTYPE_LABEL]

//download
#define DOWNLOAD_FILTER_BG              @"tu_22.png" 
#define DOWNLOAD_FILTER_BG_IMAGE ([UIImage imageNamed:DOWNLOAD_FILTER_BG])

#define FILETER_ALL_BUTTON              @"png_107"
#define FILETER_COMPLETE_BUTTON         @"png_108"
#define FILETER_DOWNLOADING_BUTTON      @"png_109"
#define FILETER_STARRED_BUTTON          @"tu_56"

#define FILETER_ALL_BUTTON_IMAGE            ([UIImage imageNamed:FILETER_ALL_BUTTON])
#define FILETER_COMPLETE_BUTTON_IMAGE       ([UIImage imageNamed:FILETER_COMPLETE_BUTTON])
#define FILETER_DOWNLOADING_BUTTON_IMAGE    ([UIImage imageNamed:FILETER_DOWNLOADING_BUTTON])
#define FILETER_STARRED_BUTTON_IMAGE        ([UIImage imageNamed:FILETER_STARRED_BUTTON])

#define FILETER_ALL_BUTTON_PRESS            @"png_111"
#define FILETER_COMPLETE_BUTTON_PRESS       @"png_112"
#define FILETER_DOWNLOADING_BUTTON_PRESS    @"png_113"
#define FILETER_STARRED_BUTTON_PRESS        @"png_11"

#define FILETER_ALL_BUTTON_PRESS_IMAGE              ([UIImage imageNamed:FILETER_ALL_BUTTON_PRESS])
#define FILETER_COMPLETE_BUTTON_PRESS_IMAGE      ([UIImage imageNamed:FILETER_COMPLETE_BUTTON_PRESS])
#define FILETER_DOWNLOADING_BUTTON_PRESS_IMAGE   ([UIImage imageNamed:FILETER_DOWNLOADING_BUTTON_PRESS])
#define FILETER_STARRED_BUTTON_PRESS_IMAGE      ([UIImage imageNamed:FILETER_STARRED_BUTTON_PRESS])


#define DOWNLOAD_CELL_BG            @"tu_100"
#define DOWNLOAD_SELECTED_BG        @"tu_102"

#define DOWNLOAD_CELL_BG_IMAGE              [UIImage strectchableImageName:DOWNLOAD_CELL_BG leftCapWidth:(218/2-1)]
#define DOWNLOAD_CELL_SELECTED_BG_IMAGE     [UIImage strectchableImageName:DOWNLOAD_SELECTED_BG leftCapWidth:(218/2-1)]

#define NAVIGATION_BAR_BG           @"tu_17"
#define NAVIGATION_BAR_TITLE_COLOR  [UIColor colorWithRed:(101/255.0) green:(134/255.0) blue:(156/255.0) alpha:1.0]

//Action
#define ITEM_ACTION_INNER_BG          @"tu_124-93"
#define ITEM_ACTION_INNER_BG_IMAGE    [UIImage strectchableImageName:ITEM_ACTION_INNER_BG]

#define ITEM_OPEN       @"tu_24-23"
#define ITEM_RENAME     @"tu_24-24"
#define ITEM_DELETE     @"png_63"
#define ITEM_FACEBOOK   @"png_65"
#define ITEM_TWITTER    @"png_66"
#define ITEM_EMAIL      @"png_64"
#define ITEM_SMS        @"png_67"
#define ITEM_MORE       @"png_68"
#define ITEM_ALBUM      @"png_69"

#define ITEM_OPEN_IMAGE       [UIImage strectchableImageName:ITEM_OPEN]
#define ITEM_RENAME_IMAGE     [UIImage strectchableImageName:ITEM_RENAME]
#define ITEM_DELETE_IMAGE     [UIImage strectchableImageName:ITEM_DELETE]
#define ITEM_FACEBOOK_IMAGE   [UIImage strectchableImageName:ITEM_FACEBOOK]
#define ITEM_TWITTER_IMAGE    [UIImage strectchableImageName:ITEM_TWITTER]
#define ITEM_EMAIL_IMAGE      [UIImage strectchableImageName:ITEM_EMAIL]
#define ITEM_SMS_IMAGE        [UIImage strectchableImageName:ITEM_SMS]
#define ITEM_MORE_IMAGE       [UIImage strectchableImageName:ITEM_MORE]
#define ITEM_ALBUM_IMAGE      [UIImage strectchableImageName:ITEM_ALBUM]

#define ITEM_OPEN_PRESS       @"png_81"
#define ITEM_RENAME_PRESS     @"png_82"
#define ITEM_DELETE_PRESS     @"png_83"
#define ITEM_FACEBOOK_PRESS   @"png_85"
#define ITEM_TWITTER_PRESS    @"png_86"
#define ITEM_EMAIL_PRESS      @"png_84"
#define ITEM_SMS_PRESS        @"png_87"
#define ITEM_MORE_PRESS       @"png_88"
#define ITEM_ALBUM_PRESS      @"png_89"

#define ITEM_OPEN_PRESS_IMAGE       [UIImage strectchableImageName:ITEM_OPEN_PRESS]
#define ITEM_RENAME_PRESS_IMAGE     [UIImage strectchableImageName:ITEM_RENAME_PRESS]
#define ITEM_DELETE_PRESS_IMAGE     [UIImage strectchableImageName:ITEM_DELETE_PRESS]
#define ITEM_FACEBOOK_PRESS_IMAGE   [UIImage strectchableImageName:ITEM_FACEBOOK_PRESS]
#define ITEM_TWITTER_PRESS_IMAGE    [UIImage strectchableImageName:ITEM_TWITTER_PRESS]
#define ITEM_EMAIL_PRESS_IMAGE      [UIImage strectchableImageName:ITEM_EMAIL_PRESS]
#define ITEM_SMS_PRESS_IMAGE        [UIImage strectchableImageName:ITEM_SMS_PRESS]
#define ITEM_MORE_PRESS_IMAGE       [UIImage strectchableImageName:ITEM_MORE_PRESS]
#define ITEM_ALBUM_PRESS_IMAGE      [UIImage strectchableImageName:ITEM_ALBUM_PRESS]



//Browser
#define BROWSER_BG                  @"tu_85-77"
#define BROWSER_BG_IMAGE            [UIImage strectchableImageName:BROWSER_BG]
#define BROSWER_VISIT_BG            @"tu_120-85"
#define BROSWER_VISIT_BG_IMAGE      [UIImage strectchableImageName:BROSWER_VISIT_BG]
#define BROSWER_INNER_BG            @"tu_03"
#define BROSWER_INNER_BG_IMAGE      [UIImage strectchableImageName:BROSWER_INNER_BG]
#define BROSWER_TEXTFIELD_BG        @"tu_120"
#define BROSWER_TEXTFIELD_BG_IMAGE  [UIImage strectchableImageName:BROSWER_TEXTFIELD_BG]

#define KEYWORD_FONT_SIZE           12
#define KEYWORD_UICOLOR             [UIColor colorWithRed:(36/255.0) green:(71/255.0) blue:(133/255.0) alpha:1.0]


//Resource
#define RESOURCE_TOP_BUTTON         @"tu_44"
#define RESOURCE_HOT_BUTTON         @"tu_45"
#define RESOURCE_NEW_BUTTON         @"png_94"
#define RESOURCE_STARRED_BUTTON     @"tu_47"

#define RESOURCE_TOP_BUTTON_IMAGE          ([UIImage imageNamed:RESOURCE_TOP_BUTTON])
#define RESOURCE_HOT_BUTTON_IMAGE          ([UIImage imageNamed:RESOURCE_HOT_BUTTON])
#define RESOURCE_NEW_BUTTON_IMAGE          ([UIImage imageNamed:RESOURCE_NEW_BUTTON])
#define RESOURCE_STARRED_BUTTON_IMAGE      ([UIImage imageNamed:RESOURCE_STARRED_BUTTON])

#define RESOURCE_TOP_BUTTON_PRESS         @"tu_48"
#define RESOURCE_HOT_BUTTON_PRESS         @"png_97"
#define RESOURCE_NEW_BUTTON_PRESS         @"png_98"
#define RESOURCE_STARRED_BUTTON_PRESS     @"tu_51"

#define RESOURCE_TOP_BUTTON_PRESS_IMAGE          ([UIImage imageNamed:RESOURCE_TOP_BUTTON_PRESS])
#define RESOURCE_HOT_BUTTON_PRESS_IMAGE          ([UIImage imageNamed:RESOURCE_HOT_BUTTON_PRESS])
#define RESOURCE_NEW_BUTTON_PRESS_IMAGE          ([UIImage imageNamed:RESOURCE_NEW_BUTTON_PRESS])
#define RESOURCE_STARRED_BUTTON_PRESS_IMAGE      ([UIImage imageNamed:RESOURCE_STARRED_BUTTON_PRESS])

#define RESOURCE_NAVIGATION_RIGHT_BUTTON        @"tu_26"
#define RESOURCE_NAVIGATION_RIGHT_BUTTON_IMAGE  [UIImage strectchableImageName:RESOURCE_NAVIGATION_RIGHT_BUTTON]

#define DOWNLOADCOUNT_LABEL_BG               @"tu_27"
#define DOWNLOADCOUNT_LABEL_BG_IMAGE         [UIImage imageNamed:DOWNLOADCOUNT_LABEL_BG]

#define ACCESSORY_ICON                      @"tu_24-21"
#define ACCESSORY_ICON_IMAGE                [UIImage imageNamed:ACCESSORY_ICON]

#define RESOURCE_CELL_BG            @"tu_96"
#define RESOURCED_SELECTED_BG        @"tu_102"

#define RESOURCE_CELL_BG_IMAGE              [UIImage strectchableImageName:RESOURCE_CELL_BG]
#define RESOURCE_CELL_SELECTED_BG_IMAGE     [UIImage strectchableImageName:RESOURCED_SELECTED_BG]
