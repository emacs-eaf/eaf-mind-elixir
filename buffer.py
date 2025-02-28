#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright (C) 2018 Andy Stewart
#
# Author:     Andy Stewart <lazycat.manatee@gmail.com>
# Maintainer: Andy Stewart <lazycat.manatee@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

from core.webengine import BrowserBuffer
from core.utils import *
from PyQt6.QtCore import QPointF, Qt
from PyQt6.QtGui import QMouseEvent
from PyQt6.QtWidgets import QApplication

class AppBuffer(BrowserBuffer):
    def __init__(self, buffer_id, url, arguments):
        BrowserBuffer.__init__(self, buffer_id, url, arguments, False)

        self.load_index_html(__file__)

    def init_app(self):
        self.init_vars()

    def init_vars(self):
        self.buffer_widget.eval_js_function(
            'initMindElixir',
            self.theme_background_color,
            self.theme_foreground_color)

    @interactive
    def update_theme(self):
        super().update_theme()
        self.init_vars()

    @interactive()
    def focus_root_node(self):
        '''
        Simulate mouse click on root node.
        '''
        print("*******")
        # 获取buffer_widget的位置和大小
        rect = self.buffer_widget.geometry()
        
        # 计算中心点位置
        center_x = rect.x() + rect.width() // 2
        center_y = rect.y() + rect.height() // 2
        
        # 创建点击位置
        click_pos = QPointF(center_x, center_y)
        
        # 创建按下事件
        press_event = QMouseEvent(
            QMouseEvent.Type.MouseButtonPress,
            click_pos,
            Qt.MouseButton.LeftButton,
            Qt.MouseButton.LeftButton,
            Qt.KeyboardModifier.NoModifier
        )
        
        # 发送按下事件
        for widget in self.get_key_event_widgets():
            post_event(widget, press_event)

        # 创建释放事件
        release_event = QMouseEvent(
            QMouseEvent.Type.MouseButtonRelease,
            click_pos,
            Qt.MouseButton.LeftButton,
            Qt.MouseButton.LeftButton,
            Qt.KeyboardModifier.NoModifier
        )
        
        # 发送释放事件
        for widget in self.get_key_event_widgets():
            post_event(widget, release_event)

        print("#######")
