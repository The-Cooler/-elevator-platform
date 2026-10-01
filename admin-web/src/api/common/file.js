import request from '@/utils/request'

// 上传单个文件
// bizType：业务类型（elevator_cert 电梯证件 / repair_evidence 报修证据 / inspection 巡检结果 / report 导出报表）
export function uploadFile(file, bizType, bizId) {
  const data = new FormData()
  data.append('file', file)
  data.append('bizType', bizType)
  if (bizId !== undefined && bizId !== null && bizId !== '') {
    data.append('bizId', bizId)
  }
  return request({
    url: '/common/file/upload',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: data
  })
}

// 批量上传文件，最多 5 个
export function uploadFileBatch(files, bizType, bizId) {
  const data = new FormData()
  files.forEach(file => data.append('files', file))
  data.append('bizType', bizType)
  if (bizId !== undefined && bizId !== null && bizId !== '') {
    data.append('bizId', bizId)
  }
  return request({
    url: '/common/file/uploadBatch',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data: data
  })
}

// 查询文件列表
export function listFile(query) {
  return request({
    url: '/common/file/list',
    method: 'get',
    params: query
  })
}

// 删除文件
export function delFile(fileId) {
  return request({
    url: '/common/file/' + fileId,
    method: 'delete'
  })
}

// 文件预览地址，图片与视频可直接用于 img / video 标签的 src
export function previewUrl(fileId) {
  if (fileId === undefined || fileId === null || fileId === '') {
    return ''
  }
  return import.meta.env.VITE_APP_BASE_API + '/common/file/preview/' + fileId
}

// 文件下载地址
export function downloadUrl(fileId) {
  if (fileId === undefined || fileId === null || fileId === '') {
    return ''
  }
  return import.meta.env.VITE_APP_BASE_API + '/common/file/download/' + fileId
}
