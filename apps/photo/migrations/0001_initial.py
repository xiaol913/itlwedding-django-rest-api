# -*- coding: utf-8 -*-
# Generated by Django 1.11.6 on 2017-10-27 19:20
from __future__ import unicode_literals

import DjangoUeditor.models
import datetime
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='PhotoInfo',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(default='', help_text='地点名称', max_length=50, verbose_name='地点名称')),
                ('desc', models.CharField(default='', help_text='地点简述', max_length=200, verbose_name='地点简述')),
                ('front_img', models.ImageField(help_text='封面图', max_length=200, upload_to='images/photo/front/', verbose_name='封面图')),
                ('photo_info', DjangoUeditor.models.UEditorField(default='', help_text='旅拍详情', verbose_name='旅拍详情')),
                ('add_time', models.DateTimeField(default=datetime.datetime.now, help_text='添加时间', verbose_name='添加时间')),
            ],
            options={
                'verbose_name': '环球旅拍详情页',
                'verbose_name_plural': '环球旅拍详情页',
            },
        ),
        migrations.CreateModel(
            name='PhotoInfoImage',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('img', models.ImageField(upload_to='images/photo/img/')),
                ('add_time', models.DateTimeField(default=datetime.datetime.now, help_text='添加时间', verbose_name='添加时间')),
                ('name', models.ForeignKey(help_text='详情', on_delete=django.db.models.deletion.CASCADE, related_name='images', to='photo.PhotoInfo', verbose_name='详情')),
            ],
            options={
                'verbose_name': '环球旅拍详情页照片',
                'verbose_name_plural': '环球旅拍详情页照片',
            },
        ),
        migrations.CreateModel(
            name='PhotoLabel',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(default='环球旅拍', help_text='该大类名称', max_length=40, verbose_name='该大类名称')),
                ('label', models.CharField(default='', help_text='标签', max_length=40, verbose_name='标签')),
                ('desc', models.TextField(blank=True, default='', help_text='描述', null=True, verbose_name='描述')),
                ('add_time', models.DateTimeField(default=datetime.datetime.now, verbose_name='添加时间')),
            ],
            options={
                'verbose_name': '环球旅拍',
                'verbose_name_plural': '环球旅拍',
            },
        ),
    ]
