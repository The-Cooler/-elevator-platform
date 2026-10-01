<script>
export default {
  onLaunch() {
    // 启动时校验本地登录态，未登录由各页面自行跳转登录页
  }
}
</script>

<style>
/* 全局样式，与后端返回的状态配色保持一致 */
page {
  background-color: #f5f7fa;
  font-size: 28rpx;
  color: #303133;
  font-family: -apple-system, BlinkMacSystemFont, 'PingFang SC', 'Helvetica Neue', Arial, sans-serif;
}

.page-wrap {
  padding: 24rpx;
}

.card {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 28rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(11, 61, 145, 0.06);
}

.card-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #303133;
  margin-bottom: 20rpx;
}

.row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.row-between {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16rpx;
}

.label {
  color: #909399;
  font-size: 26rpx;
}

.value {
  color: #303133;
  font-size: 26rpx;
}

.btn-primary {
  background: #0b3d91;
  color: #ffffff;
  border-radius: 12rpx;
  font-size: 30rpx;
  line-height: 88rpx;
  text-align: center;
  border: none;
}

.btn-primary::after {
  border: none;
}

.btn-outline {
  background: #ffffff;
  color: #0b3d91;
  border: 2rpx solid #0b3d91;
  border-radius: 12rpx;
  font-size: 30rpx;
  line-height: 84rpx;
  text-align: center;
}

.tag {
  padding: 4rpx 16rpx;
  border-radius: 20rpx;
  font-size: 22rpx;
  line-height: 36rpx;
}

.tag-pending {
  background: #fef5e7;
  color: #b3730d;
}

.tag-assigned {
  background: #ebf0fa;
  color: #0b3d91;
}

.tag-repairing {
  background: #e8f6f0;
  color: #0f6e4c;
}

.tag-done {
  background: #e8f6f0;
  color: #0f6e4c;
}

.tag-danger {
  background: #fdecec;
  color: #a62e32;
}

.tag-muted {
  background: #f5f7fa;
  color: #6b7688;
}

.empty {
  text-align: center;
  color: #98a1b0;
  font-size: 28rpx;
  padding: 100rpx 0;
}

.field {
  margin-bottom: 28rpx;
}

.field-label {
  font-size: 28rpx;
  color: #606266;
  margin-bottom: 12rpx;
}
</style>
