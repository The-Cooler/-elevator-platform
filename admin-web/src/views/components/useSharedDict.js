import { getDicts } from '@/api/system/dict/data'

/**
 * 带请求去重的字典加载
 *
 * 若依自带的 useDict 每个调用方各发一次请求，状态标签组件在一张表格里会渲染几十次，
 * 直接使用会产生几十个重复的字典请求。此方法按字典类型缓存 ref，并复用同一个在途请求，
 * 供 OrderStatusTag、FaultLevelTag、DictSelect 这类可能被大量实例化的组件共用。
 *
 * 返回的是同一个 ref 实例，字典在首次加载完成后所有组件同时更新。
 */
const dictCache = new Map()
const inflightCache = new Map()

export function useSharedDict(dictType) {
  if (!dictType) {
    return ref([])
  }
  if (!dictCache.has(dictType)) {
    dictCache.set(dictType, ref([]))
  }
  const dictRef = dictCache.get(dictType)
  if (dictRef.value.length === 0 && !inflightCache.has(dictType)) {
    const promise = getDicts(dictType).then(resp => {
      dictRef.value = (resp.data || []).map(item => ({
        label: item.dictLabel,
        value: item.dictValue,
        elTagType: item.listClass,
        elTagClass: item.cssClass
      }))
    }).catch(() => {
      // 字典加载失败时保持空数组，组件按内置兜底文案渲染
      dictRef.value = []
    }).finally(() => {
      inflightCache.delete(dictType)
    })
    inflightCache.set(dictType, promise)
  }
  return dictRef
}

/**
 * 清空字典缓存，字典维护页面修改字典后调用
 */
export function clearSharedDict(dictType) {
  if (dictType) {
    dictCache.delete(dictType)
  } else {
    dictCache.clear()
  }
}
