<template>
  <div class="media-preview">
    <div v-if="!files.length" class="media-empty">暂无图片或视频</div>
    <div v-else class="media-list">
      <div
        v-for="(file, index) in files"
        :key="file.fileId"
        class="media-item"
      >
        <el-image
          v-if="file.mediaType === 'image'"
          :src="buildUrl(file.fileId)"
          :preview-src-list="imageUrlList"
          :initial-index="imageIndex(file)"
          fit="cover"
          preview-teleported
          class="media-image"
        >
          <template #error>
            <div class="media-slot">
              <el-icon><Picture /></el-icon>
            </div>
          </template>
        </el-image>

        <video
          v-else-if="file.mediaType === 'video'"
          :src="buildUrl(file.fileId)"
          controls
          preload="metadata"
          class="media-video"
        ></video>

        <a
          v-else
          :href="buildDownloadUrl(file.fileId)"
          target="_blank"
          class="media-file"
        >
          <el-icon><Document /></el-icon>
          <span>{{ file.fileName || ('附件' + file.fileId) }}</span>
        </a>

        <div v-if="showCaption" class="media-caption">
          <span :title="file.fileName">{{ file.fileName || ('文件' + file.fileId) }}</span>
          <el-icon class="media-remove" v-if="removable" @click="handleRemove(index)"><Close /></el-icon>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup name="MediaPreview">
/**
 * 图片视频预览组件
 * 接收 fileId 列表，图片与视频统一走 GET /common/file/preview/{fileId}
 *
 * 支持两种入参形式：
 *   1. [1, 2, 3]                                  纯 fileId 数组，类型按图片处理
 *   2. [{ fileId: 1, fileType: 'image', fileName: '现场照片.jpg' }]  带类型与文件名
 */
import { previewUrl, downloadUrl } from '@/api/common/file'

const props = defineProps({
  // fileId 列表或文件对象列表
  fileIds: {
    type: Array,
    default: () => []
  },
  // 是否显示文件名与删除按钮
  showCaption: {
    type: Boolean,
    default: false
  },
  // 是否允许删除，需配合 remove 事件使用
  removable: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['remove'])

// 统一成 { fileId, fileType, mediaType, fileName }
const files = computed(() => {
  return (props.fileIds || []).filter(item => item !== null && item !== undefined).map(item => {
    if (typeof item === 'object') {
      const fileType = item.fileType || 'image'
      return {
        fileId: item.fileId,
        fileName: item.fileName || '',
        fileType: fileType,
        mediaType: resolveMediaType(fileType, item.fileSuffix)
      }
    }
    return {
      fileId: item,
      fileName: '',
      fileType: 'image',
      mediaType: 'image'
    }
  })
})

const imageUrlList = computed(() => {
  return files.value.filter(f => f.mediaType === 'image').map(f => buildUrl(f.fileId))
})

function resolveMediaType(fileType, suffix) {
  if (fileType === 'image' || fileType === 'video') {
    return fileType
  }
  const ext = (suffix || '').toLowerCase()
  if (['mp4', 'mov', 'avi', 'webm'].includes(ext)) {
    return 'video'
  }
  if (['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'].includes(ext)) {
    return 'image'
  }
  return 'file'
}

function imageIndex(file) {
  return imageUrlList.value.indexOf(buildUrl(file.fileId))
}

function buildUrl(fileId) {
  return previewUrl(fileId)
}

function buildDownloadUrl(fileId) {
  return downloadUrl(fileId)
}

function handleRemove(index) {
  emit('remove', files.value[index], index)
}
</script>

<style scoped lang="scss">
.media-preview {
  width: 100%;
}

.media-empty {
  color: #909399;
  font-size: 13px;
  line-height: 32px;
}

.media-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.media-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.media-image,
.media-video {
  width: 110px;
  height: 82px;
  border-radius: 4px;
  background-color: #f5f7fa;
  border: 1px solid #ebeef5;
  object-fit: cover;
}

.media-file {
  display: flex;
  align-items: center;
  gap: 4px;
  width: 110px;
  height: 82px;
  justify-content: center;
  font-size: 12px;
  color: #409eff;
  text-decoration: none;
  border-radius: 4px;
  background-color: #f5f7fa;
  border: 1px solid #ebeef5;
  overflow: hidden;
  padding: 0 4px;
  text-align: center;
}

.media-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  color: #909399;
  font-size: 24px;
}

.media-caption {
  display: flex;
  align-items: center;
  gap: 4px;
  max-width: 110px;
  margin-top: 4px;
  font-size: 12px;
  color: #606266;

  span {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .media-remove {
    cursor: pointer;
    color: #f56c6c;
    flex-shrink: 0;
  }
}
</style>
