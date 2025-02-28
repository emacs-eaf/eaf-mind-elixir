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
import os

class AppBuffer(BrowserBuffer):
    def __init__(self, buffer_id, url, arguments):
        BrowserBuffer.__init__(self, buffer_id, url, arguments, False)

        self.load_index_html(__file__)

    def init_app(self):
        self.init_file()
        self.init_colors()

    def init_colors(self):
        self.buffer_widget.eval_js_function(
            'initColors',
            self.theme_background_color,
            self.theme_foreground_color)

    @interactive
    def update_theme(self):
        super().update_theme()
        self.buffer_widget.eval_js_function(
            'updateTheme',
            self.theme_background_color,
            self.theme_foreground_color)

    @interactive()
    def focus_root_node(self):
        '''
        Simulate mouse click on root node.
        '''
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

    def init_file(self):
        self.url = os.path.expanduser(self.url)

        if os.path.exists(self.url):
            with open(self.url, "r") as f:
                # 读取.eme文件内容
                data = f.read()
                self.buffer_widget.eval_js_function("openFile", string_to_base64(data))
        else:
            # 如果是新文件，初始化一个空的思维导图
            self.buffer_widget.eval_js_function("initRootNode")

    @interactive(insert_or_do=True)
    def save_file(self, notify=True):
        '''
        Save mind map to .eme file.
        '''
        file_path = self.url
        
        # 获取mind map数据
        data = self.buffer_widget.execute_js("saveFile();")
        
        # 写入文件
        with open(file_path, "w") as f:
            f.write(data)

        if notify:
            message_to_emacs("Save file: " + file_path)

    @interactive()
    def paste_to_node_topic(self):
        '''
        Paste Emacs clipboard content to current node topic.
        '''
        # 获取Emacs剪贴板内容
        clipboard_text = self.get_clipboard_text()
        
        if clipboard_text:
            # 调用JavaScript方法设置节点标题
            self.buffer_widget.eval_js_function("setNodeTopic", clipboard_text)
            message_to_emacs(f"Pasted: {clipboard_text}")
        else:
            message_to_emacs("Clipboard is empty")

    @interactive()
    def copy_node_topic(self):
        '''
        Copy current node topic to Emacs clipboard.
        '''
        # 获取当前节点标题
        node_topic = self.buffer_widget.execute_js("getNodeTopic();")
        
        # 添加调试信息
        current_node = self.buffer_widget.execute_js("this.mindElixir && this.mindElixir.currentNode ? 'yes' : 'no';")
        message_to_emacs(f"Current node exists: {current_node}")
        
        if node_topic:
            # 复制到Emacs剪贴板
            eval_in_emacs('kill-new', [node_topic])
            message_to_emacs(f"Copied: {node_topic}")
        else:
            message_to_emacs("No node selected")

    @interactive()
    def debug_node_info(self):
        '''
        Debug node information.
        '''
        debug_info = self.buffer_widget.execute_js("debugNodeInfo();")
        message_to_emacs(f"Debug info: {debug_info}")

