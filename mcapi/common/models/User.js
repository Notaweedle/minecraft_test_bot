const { DataTypes } = require('sequelize');

const UserModel = {
  id: { type: DataTypes.INTEGER, autoIncrement: true, primaryKey: true },
  username: { type: DataTypes.STRING, allowNull: false, unique: true },
  password: { type: DataTypes.STRING, allowNull: false },
  serverIp: { type: DataTypes.STRING, allowNull:  false, unique: true},
  serverPort: { type: DataTypes.NUMBER, allowNull:  false, unique: true},
  serverPassword: { type: DataTypes.STRING, allowNull:  false, unique: true},
};

module.exports = (sequelize) => sequelize.define('user', UserModel);